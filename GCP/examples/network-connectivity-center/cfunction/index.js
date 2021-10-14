'use strict'

const { google } = require('googleapis')
const { GoogleAuth } = require('google-auth-library')
const auth = new GoogleAuth()
const compute = google.compute('v1')

const { HubServiceClient } = require('@google-cloud/network-connectivity')
const axios = require('axios')

const name = process.env.NAME
const projectId = process.env.PROJECT_ID
const hubName = process.env.HUB_NAME
const fgtInstanceSpoke = process.env.FGT_INSTANCE_SPOKE
const regionSpoke = process.env.REGION_SPOKE
const zoneSpoke = process.env.ZONE_SPOKE
const crSpoke = process.env.CLOUD_ROUTER_SPOKE
const vpcSpoke = process.env.VPC_SPOKE
const subnetSpoke = process.env.SUBNET_SPOKE
const crBGPAsnSpoke = process.env.CR_BGP_ASN_SPOKE
const crBGPPeersPeerAsnSpoke = process.env.CR_BGPPEERS_PEERASN_SPOKE
const interfacePrivateIP1Spoke = process.env.INTERFACE_PRIVATE_IP_1_SPOKE
const interfacePrivateIP2Spoke = process.env.INTERFACE_PRIVATE_IP_2_SPOKE
let routerApplianceSpoke = null
let peerIPAddressSpoke = null

const hubLocation = 'global'

console.info(projectId)
console.info(hubName)
console.info(fgtInstanceSpoke)
console.info(regionSpoke)
console.info(zoneSpoke)
console.info(crSpoke)
console.info(vpcSpoke)
console.info(subnetSpoke)
console.info(crBGPAsnSpoke)
console.info(crBGPPeersPeerAsnSpoke)
console.info(interfacePrivateIP1Spoke)
console.info(interfacePrivateIP2Spoke)

/**
 * Function to fetch access token
 */
const fetchJwtAccessToken = async () => {
  console.info("Invoked fetchJwtAccessToken !!!")
  const auth = new google.auth.GoogleAuth({
    scopes: ['https://www.googleapis.com/auth/cloud-platform']
  })
  const accessToken = await auth.getAccessToken()
  return accessToken
}

/**
 *  Function to fetch Compute Engine Data
 */
const fetchComputeEngine = async () => {
  console.info("Invoked fetchComputeEngine !!!")
  try {
    const computeAuthClient = await google.auth.getClient({
      scopes: [
        'https://www.googleapis.com/auth/cloud-platform',
        'https://www.googleapis.com/auth/compute',
        'https://www.googleapis.com/auth/compute.readonly',
      ],
    })
    const projectId = await google.auth.getProjectId()
    const result = await compute.instances.get({
      auth: computeAuthClient,
      project: projectId,
      instance: fgtInstanceSpoke,
      zone: zoneSpoke
    })
    routerApplianceSpoke = result.data.selfLink
    peerIPAddressSpoke = result.data.networkInterfaces[0].networkIP
    return result
  } catch (err) {
    console.error('ERROR while fetching Compute Engine Details: ', err)
  }
}

/**
 * Function to Update Cloud Router with the BGP Peers and Interfaces 
 * API Reference: https://cloud.google.com/network-connectivity/docs/network-connectivity-center/how-to/creating-router-appliances#create-two-bgp-peers
 */
const updateCloudRouter = async (jwtAccessToken) => {
  console.info("Invoked updateCloudRouter !!!")
  const crPatchURI = 'https://compute.googleapis.com/compute/beta/projects/' + projectId + '/regions/' + regionSpoke + '/routers/' + crSpoke
  const header = { 'Authorization': 'Bearer ' + jwtAccessToken }

  const crObj = {
    network: vpcSpoke,
    bgp: {
      asn: crBGPAsnSpoke
    },
    bgpPeers: [
      {
        name: crSpoke + '-bgppeer1',
        interfaceName: crSpoke + '-interface0',
        ipAddress: interfacePrivateIP1Spoke,
        peerIpAddress: peerIPAddressSpoke,
        routerApplianceInstance: routerApplianceSpoke,
        peerAsn: crBGPPeersPeerAsnSpoke
      },
      {
        name: crSpoke + '-bgppeer2',
        interfaceName: crSpoke + '-interface1',
        ipAddress: interfacePrivateIP2Spoke,
        peerIpAddress: peerIPAddressSpoke,
        routerApplianceInstance: routerApplianceSpoke,
        peerAsn: crBGPPeersPeerAsnSpoke
      }
    ],
    interfaces: [{
      name: crSpoke + '-interface0',
      privateIpAddress: interfacePrivateIP1Spoke,
      subnetwork: subnetSpoke
    }, {
      name: crSpoke + '-interface1',
      privateIpAddress: interfacePrivateIP2Spoke,
      subnetwork: subnetSpoke,
      redundantInterface: crSpoke + '-interface0',
    }]
  }

  // Axios invoking the API to patch Cloud Router with other information
  try {
    const uCrSpoke = await axios
      .patch(crPatchURI, crObj, {
        headers: header
      })
      .then(res => {
        console.info(`Successfully Updated Cloud Router : ${res.status}`)
        return res.status
      })
      .catch(error => {
        console.error('ERROR while updating Cloud Router with BGP Peers : ', error)
      })
    return uCrSpoke
  } catch (err) {
    console.error('ERROR while updating Cloud Router with BGP Peers : ', err)
  }
}

/**
 *  Function to Validate if the Hub Exists
 */
const validateIfHubExists = async (hubServiceClient) => {
  let hubExists = false
  try {
    const [hub] = await hubServiceClient.getHub({
      name: `projects/${projectId}/locations/${hubLocation}/hubs/${hubName}`,
    })
    hubExists = true
    console.info('Hub Exists :' + hubExists)
  } catch (err) {
    // console.error('ERROR while fetching Hub: ', err)
    console.error('Hub Exists :' + hubExists)
  }
  return hubExists
}

/**
 *  Function to Create a Hub given the Hub Name
 */
const createHub = async (hubServiceClient) => {
  try {
    const [operation] = await hubServiceClient.createHub({
      parent: `projects/${projectId}/locations/${hubLocation}`,
      hubId: hubName
    })
    const [response] = await operation.promise()
    return response
  } catch (err) {
    console.error('ERROR while creating a Hub: ', err)
  }
}

/**
 *  Function to Create a Spoke and attach to the Hub
 */
const createSpoke = async (hubServiceClient) => {
  try {
    const spokeProperties = {}
    spokeProperties.name = hubName + '-' + regionSpoke + '-' + name
    spokeProperties.hub = hubName
    spokeProperties.siteToSiteDataTransfer = false
    spokeProperties.linkedRouterApplianceInstances = [
      {
        'ipAddress': peerIPAddressSpoke,
        'virtualMachine': routerApplianceSpoke
      }
    ]
    const [operation] = await hubServiceClient.createSpoke({
      parent: `projects/${projectId}/locations/${regionSpoke}`,
      spoke: spokeProperties,
      spokeId: hubName + '-' + regionSpoke + '-' + name,
    })
    const [response] = await operation.promise()
    return response
  } catch (err) {
    console.error('ERROR while creating a Spoke: ', err)
  }
}

/**
 * Function to validate and Construct NCC Configuration
 */
const constructNCC = async () => {
  console.info("Invoked validateNCC")

  const newComputeEngine = await fetchComputeEngine()

  // Fetch Access Token
  const jwtAccessToken = await fetchJwtAccessToken()

  // Update Cloud Router with the BGP Peers and Interfaces
  const updatedCloudRouter = await updateCloudRouter(jwtAccessToken)

  // Validate if a Hub exists
  // Creates a HubServiceClient
  const hubServiceClient = new HubServiceClient()
  const validateHubExists = await validateIfHubExists(hubServiceClient)

  // If Hub doesn't exist, then create a new Hub.
  if (!validateHubExists) {
    const newHub = await createHub(hubServiceClient)
    console.info("Successfully Created Hub.")
  }

  // Create Spoke and Attach to the Hub
  const newSpoke = await createSpoke(hubServiceClient)
  console.info("Successfully created Spoke and attached to the Hub.")
  return newSpoke
}

exports.invokeNCC = async (req, res) => {
  try {
    const nccConfig = constructNCC()
    res.send('Constructing NCC Configuration')
  } catch (err) {
    console.error(err)
    res.status(err.code || 500).send(err)
    return Promise.reject(err)
  }
}