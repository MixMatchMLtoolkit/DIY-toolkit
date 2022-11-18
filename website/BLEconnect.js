//Code for BLE connection from: https://itpnyu.github.io/p5ble-website/docs/getstarted


//Variables for BLE connection
const serviceUuid = "e098a7b1-9074-4e8f-bb89-2a8e84a1a271"; //should match with the serviceUuid from the Arduino code
let isConnected = false;
var connectButton;
var disconnectButton;

//Variables for reading the tag ID's
var identifier;
var incomingValues = [255, 255]; //255 is the received value if no token is presented, so start with "empty array"
var emptyArray = [255, 255];
var tags = [255, 255];
var loc = [0, 0]; //keep track where a token is present, (1= present on that position)
var tagsPresent = 0; //keep track of number of tokens that are present

var tag1; //the tagID of tag1
var tag2; //the tagID of tag2
var tagRemoved = false;

var modeValue = 78; //start with normal mode
var oldModeValue = 78;

var emptyBefore=false;//use this to only load the info page once instead of constantly --> buttons don't work otherwise
var modeSelectBefore =false;// use this to only load the select mode page once instead of constantly --> buttons don't work otherwise


function setup() {
  // Create a p5ble class
  myBLE = new p5ble();

  //Connect button for the BLE
  connectButton = select('#connectBLE');
  connectButton.mousePressed(connectToBle);

}

function connectToBle() {
  // Connect to a device by passing the service UUID
  myBLE.connect(serviceUuid, gotCharacteristics);
  document.getElementById("connecting").style.visibility = "visible";
}

function disconnectToBle() {
  // Disonnect to the device
  myBLE.disconnect();
  // Check if myBLE is connected
  isConnected = myBLE.isConnected();

}

function onDisconnected() {
  //If the device is disconnected, send an alert and reload the page so they can connect again
  console.log('Device got disconnected.');
  alert("Sensor board got disconnected");
  location.reload();
  isConnected = false;
}


// A function that will be called once got characteristics
function gotCharacteristics(error, characteristics) {
  // Add a event handler when the device is disconnected
  myBLE.onDisconnected(onDisconnected)
  if (error) console.log('error: ', error);
  console.log('characteristics: ', characteristics);
  myCharacteristic = characteristics[0];
  deviceName = characteristics[0].service.device.name;
  // var name = instanceOfBluetoothDevice.name
  console.log(deviceName);
  // Start notifications on the first characteristic by passing the characteristic
  // And a callback function to handle notifications
  myBLE.startNotifications(myCharacteristic, handleNotifications);
  // You can also pass in the dataType
  // Options: 'unit8', 'uint16', 'uint32', 'int8', 'int16', 'int32', 'float32', 'float64', 'string'
  // myBLE.startNotifications(myCharacteristic, handleNotifications, 'string');

  // Check if myBLE is connected
  isConnected = myBLE.isConnected();
  if (isConnected) {
    document.getElementById("continue").style.visibility = "visible";
    document.getElementById("connected").style.visibility = "visible";
    document.getElementById("connecting").style.visibility = "hidden";
  }

}

// A function that will be called once got characteristics
function handleNotifications(data) {
  myValue = data;
  //console.log(myValue);
  if (myValue == 0 | myValue == 1) {
    identifier = myValue;
  } else if (myValue == 67 | myValue == 78) {
    //mode myValue
    //  console.log(myValue);
    checkMode2(myValue);
    } else if (myValue == 254) {
    disconnectToBle();
  } else {
    incomingValues[identifier] = myValue;
  }
  readValues();

}

function checkMode2(modeVal) {
  if (modeVal != oldModeValue) {
    //update mode
    if (modeVal == 67) {
      //  console.log("Compare modus");
      mode2 = 'compare';
      resetReading();
    } else if (modeVal == 78) {
      //  console.log('normal');
      mode2 = "normal";
      resetReading();
    }
  }
  oldModeValue = modeVal;
}

function resetReading() {
  tags = [255, 255];
  tagsPresent = 0;
  tagRemoved = false;
}

function readValues() {
//  console.log(incomingValues);
  //in case someone continues using the board without closing the alert, this code will make sure it will only opens the combination page instead of both the ability and combination page underneath each other
  //it checks if three or more things are shown and if this is the case, only shows the combination page
  if (document.getElementsByClassName("headerData").length > 2) {
    numPages(2);
  }
  //check if there is at least one token available
  if (arrayEquals(incomingValues, emptyArray)) {
    //if not: open information page (0) but only when it is the first time reading it as empty (emptyBefore=false)
    if(!emptyBefore){
    open1Page(0);
  } else {

  }
  }
  if (!arrayEquals(incomingValues, tags)) { //if something changed after the previous situation, check if tokens are removed and update page
    console.log(incomingValues, tags);
    emptyBefore=false;//set back to false
    removeTags();
    // updateTags();
  }
}

function removeTags() {
  for (let i = 0; i < incomingValues.length; i++) {
    //console.log(tags);
    if (incomingValues[i] == 255 && tags[i] != 255) {
      //if no tag present on reader[i], then remove one tag present and remove value from tag[]
      // console.log("tag removed");
      tagRemoved = true;
      tagsPresent--;
      tags[i] = 255;
      loc[i] = 0; // 1: tag is present, 0: no tag present
      // updateTags();
    } //if
  } //for
  updateTags();
}

function updateTags() {
  //console.log(tagRemoved);
  if (!arrayEquals(incomingValues, emptyArray)) {
    //loop over the incomingValues to detect how many tags are present, their location and their ID.
    for (let i = 0; i < incomingValues.length; i++) {
      //check if != 255 --> token present
      if (incomingValues[i] != 255) {
        //console.log("Tag present");
        if (incomingValues[i] != tags[i]) { //only for new tags
          tagsPresent++; //add 1 to number of tagsPresent
          tags[i] = incomingValues[i]; //save the tag number for identification later
          loc[i] = 1; // 1: tag is present, 0: no tag present
          // console.log(i + ", " + tags[i] + ", " + tagsPresent);
          // numPages(tagsPresent);
        }
        // else if (tagRemoved) { //if a tag is removed, the if-loop above will not rerun since the remaining token is the same, so in that case run this elseif
        //   tags[i] = incomingValues[i];
        //   // console.log(i + ",, " + tags[i] + ", " + tagsPresent);
        //   // numPages(tagsPresent);
        //     console.log("if loop2");
        //   tagRemoved = false;
        // }
      } //if
    } //for
    //console.log(tagsPresent);
    numPages(tagsPresent);
  } else {
    tagRemoved = false;
  }
}

function numPages(numTags) {
  //  console.log("tagspresent: " + numTags);
  switch (numTags) {
    case 3: //3 tags not possible so set back to 0
      console.log("Reset reading");
      resetReading();
      break;
    case 2: //2 tags present
     console.log("2 tags present");
      tag1 = tags[0];
      tag2 = tags[1];
      openCombiPage(tag1, tag2);
      break;
    case 1: //1 tag present if loc[0]: data, loc[1]: label, loc[2]: ability
      //show data or ability page depending on token
      // console.log("1 tag present");
      tag1 = tags[tags.findIndex(findTag)];
      // console.log("tag1: "+tag1);
      open1Page(tag1);
      break;

    default: //0 tags
  }
}

//Check which of the arrays contain the token ID and open the corresponding page
function open1Page(tagID) {
  if (tagID == 0) {
    if (mode === 'none' ) {
      if (modeSelectBefore== false){
        modeSelectBefore= true;
        console.log(modeSelectBefore);
        openModeSelect();
      }

    } else {
      emptyBefore=true;
      openInfo();
      console.log('empty');
    }

  } else if (labeledDataTokens.includes(tagID)) {
    //  openDataPage(transform('datatypes.xml', 'datatokens.xsl', 'Text'));
    openDataPage(transform('datatypes.xml', 'labeleddata.xsl', tagID));
    sendOOCSI('labeleddatapage', tagID, 0);
  } else if (unlabeledDataTokens.includes(tagID)) {
    openDataPage(transform('datatypes.xml', 'unlabeleddata.xsl', tagID));
    sendOOCSI('unlabeleddatapage', tagID, 0);
  } else if (supTokens.includes(tagID)) {
    openAbilityPage(transform('abilities.xml', 'supervised.xsl', tagID));
    sendOOCSI('supervised', tagID, 0);
  } else if (unsupTokens.includes(tagID)) {
    openAbilityPage(transform('abilities.xml', 'unsupervised.xsl', tagID));
    sendOOCSI('unsupervised', tagID, 0);
  } else if (reinTokens.includes(tagID)) {
    openAbilityPage(transform('abilities.xml', 'reinforcement.xsl', tagID));
    sendOOCSI('reinforcement', tagID, 0);
  } else {
    openInfo();

    //alert('Token not recognized');
    // tagsPresent=0;
    // readValues();

  }
}

//In case two tokens are present, check if it is valid combination. If yes, then open the correct combination page and otherwise give an alert and return to info page
function openCombiPage(tag1, tag2) {
  // console.log(tag1);
  console.log(mode2);
  if (mode2 === "normal") {
    console.log(tag1, tag2);
    if (labeledDataTokens.includes(tag1) && (supTokens.includes(tag2) || unsupTokens.includes(tag2))) {
      openCombinationPage(transform2('combies.xml', 'combies.xsl', tag1, tag2));
      sendOOCSI('combination', tag1, tag2);
    } else if (unlabeledDataTokens.includes(tag1) && unsupTokens.includes(tag2)) {
      // console.log(tag1);
      // let i = unlabeledDataTokens.indexOf(tag1);
      openCombinationPage(transform2('combies.xml', 'combies.xsl', tag1, tag2));
      sendOOCSI('combination', tag1, tag2);
    } //if tokens are reversed still work
    else if (labeledDataTokens.includes(tag2) && (supTokens.includes(tag1) || unsupTokens.includes(tag1))) {
      openCombinationPage(transform2('combies.xml', 'combies.xsl', tag2, tag1));
      sendOOCSI('combination', tag2, tag1);
    } else if (unlabeledDataTokens.includes(tag2) && unsupTokens.includes(tag1)) {
      // console.log(tag1);
      // let i = unlabeledDataTokens.indexOf(tag1);
      openCombinationPage(transform2('combies.xml', 'combies.xsl', tag2, tag1));
      sendOOCSI('combination', tag2, tag1);
    } else {
      openNoCombi();
      console.log("incorrect combination");
    }

  } else if (mode2 === "compare") {
    console.log("Compare mode");
    if ((labeledDataTokens.includes(tag1) || unlabeledDataTokens.includes(tag1)) && (labeledDataTokens.includes(tag2) || unlabeledDataTokens.includes(tag2))) {
      openComparePage(transformCompare('datatypes.xml', 'comparedata.xsl', tag2, tag1));
    } else if (abilityTokens.includes(tag1) && abilityTokens.includes(tag2)) {
      openComparePage(transformCompare('abilities.xml', 'compareabilities.xsl', tag2, tag1));
    } else if (labeledDataTokens.includes(tag1) && (supTokens.includes(tag2) || unsupTokens.includes(tag2))) {
      openCombinationPage(transform2('combies.xml', 'combies.xsl', tag1, tag2));
      sendOOCSI('combination', tag1, tag2);
    } else if (unlabeledDataTokens.includes(tag1) && unsupTokens.includes(tag2)) {
      // console.log(tag1);
      // let i = unlabeledDataTokens.indexOf(tag1);
      openCombinationPage(transform2('combies.xml', 'combies.xsl', tag1, tag2));
      sendOOCSI('combination', tag1, tag2);

    }

    //if tokens are reverse still work
    else if (labeledDataTokens.includes(tag2) && (supTokens.includes(tag1) || unsupTokens.includes(tag1))) {
      openCombinationPage(transform2('combies.xml', 'combies.xsl', tag2, tag1));
      sendOOCSI('combination', tag2, tag1);
    } else if (unlabeledDataTokens.includes(tag2) && unsupTokens.includes(tag1)) {
      // console.log(tag1);
      // let i = unlabeledDataTokens.indexOf(tag1);
      openCombinationPage(transform2('combies.xml', 'combies.xsl', tag2, tag1));
      sendOOCSI('combination', tag2, tag1);
    }
  }


}

//source: https://masteringjs.io/tutorials/fundamentals/compare-arrays
function arrayEquals(a, b) {
  return Array.isArray(a) &&
    Array.isArray(b) &&
    a.length === b.length &&
    a.every((val, index) => val === b[index]);
}

function findTag(tag) {
  return tag != 255;
}

function showhideInfo() {
  var x = document.getElementById("descHidden");
  if (x.style.display === "block") {
    x.style.display = "none";
  } else {
    x.style.display = "block";
  }
}

function showhideLeft() {
  var x = document.getElementById("fullspanCompareLeft");

  if (x.style.display === "block") {
    document.getElementById("openCapLim").innerHTML = "Show capabilities and limitations";
    x.style.display = "none";
  } else {
    document.getElementById("openCapLim").innerHTML = "Close capabilities and limitations";
    x.style.display = "block";
  }
}

function showhideRight() {
  var x = document.getElementById("fullspanCompareRight");
  if (x.style.display === "block") {
    document.getElementById("openCapLimR").innerHTML = "Show capabilities and limitations";
    x.style.display = "none";
  } else {
    document.getElementById("openCapLimR").innerHTML = "Close capabilities and limitations";
    x.style.display = "block";
  }
}

function showhideDataLeft() {
  var x = document.getElementById("descHiddenLeft");
  if (x.style.display === "block") {
    x.style.display = "none";
  } else {
    x.style.display = "block";
  }
}

function showhideDataRight() {
  var x = document.getElementById("descHiddenRight");
  if (x.style.display === "block") {
    x.style.display = "none";
  } else {
    x.style.display = "block";
  }
}

function changeMode() {
  //console.log("check");
  educationMode = document.getElementById("switchMode").checked;
  console.log("Education mode: " + educationMode);
  console.log(typePage);
  changeDisplay();
}

function selectMode(modeSelected) {
  if (modeSelected === 'education') {
    educationMode = true;
    mode = 'education';
  } else {
    educationMode = false;
    mode = 'normal';
  }

  console.log("Education mode: " + educationMode);
}


function changeDisplay() {
  if (typePage === "data") {
    var id = 'descHidden';
    if (educationMode) {
      document.getElementById(id).style.display = 'block';
    } else {
      document.getElementById(id).style.display = 'none';
    }
  } else if (typePage === "capability") {
    var id = "fullspanCompareLeft";

    if (educationMode) {
      document.getElementById("openCapLim").innerHTML = "Close capabilities and limitations";
      document.getElementById(id).style.display = 'block';
    } else {
      document.getElementById("openCapLim").innerHTML = "Show capabilities and limitations";
      document.getElementById(id).style.display = 'none';
    }
  } else if (typePage === 'compareabilities') {
    if (educationMode) {
      document.getElementById("fullspanCompareLeft").style.display = 'block';
      document.getElementById("fullspanCompareRight").style.display = 'block';
      document.getElementById("openCapLim").innerHTML = "Close capabilities and limitations";
      document.getElementById("openCapLimR").innerHTML = "Close capabilities and limitations";
    } else {
      document.getElementById("fullspanCompareLeft").style.display = 'none';
      document.getElementById("fullspanCompareRight").style.display = 'none';
      document.getElementById("openCapLim").innerHTML = "Show capabilities and limitations";
      document.getElementById("openCapLimR").innerHTML = "Show capabilities and limitations";
    }
  } else if (typePage === 'comparedata') {
    if (educationMode) {
      document.getElementById("descHiddenLeft").style.display = 'block';
      document.getElementById("descHiddenRight").style.display = 'block';
    } else {
      document.getElementById("descHiddenLeft").style.display = 'none';
      document.getElementById("descHiddenRight").style.display = 'none';
    }

  }

}
