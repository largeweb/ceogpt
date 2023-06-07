const express = require("express");
const cors = require("cors");
const { spawn, exec } = require("child_process");
const YAML = require("yamljs");
const fs = require("fs");
const path = require("path");
const app = express();
require("dotenv").config();
const port = process.env.PORT || 3333;
app.use(cors());
app.use(express.json());

const initialprompt = fs.readFileSync(
  path.join(__dirname, "prompts", "initialprompt.txt"),
  "utf8"
);
const datetime = fs.readFileSync(
  path.join(__dirname, "prompts", "datetime.txt"),
  "utf8"
);
const details = fs.readFileSync(
  path.join(__dirname, "prompts", "details.txt"),
  "utf8"
);
const availableactions = fs.readFileSync(
  path.join(__dirname, "prompts", "availableactions.txt"),
  "utf8"
);
const endingprompt = fs.readFileSync(
  path.join(__dirname, "prompts", "endingprompt.txt"),
  "utf8"
);

const updateDatetime = () => {
  const currentdate = new Date();
  const months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];
  const month = months[currentdate.getMonth()];
  const day = currentdate.getDate();
  const year = currentdate.getFullYear();
  const hours = currentdate.getHours();
  const minutes =
    currentdate.getMinutes() < 10
      ? "0" + currentdate.getMinutes()
      : currentdate.getMinutes();
  const ampm = hours >= 12 ? "PM" : "AM";
  const hours12 = hours % 12 || 12;
  const time = hours12 + ":" + minutes + " " + ampm;
  const datetime =
    "Time: Today is " +
    month +
    " " +
    day +
    ", " +
    year +
    ". The Time is " +
    time +
    ".";
  fs.writeFileSync(path.join(__dirname, "prompts", "datetime.txt"), datetime);
};

app.post("/update-action-and-metrics", async (req, res) => {
  const largegoal = "Large Goal: " + req.body.largegoal;
  const companystatus = "Company Status: " + req.body.companystatus;
  const recentcontext = "History: " + req.body.recentcontext;
  const nextaction = "Next Action: " + req.body.nextaction;
  const actioninput = req.body.actioninput;
  const narrowgoal = "Narrow Goal: " + req.body.narrowgoal;
  const thinking = "CEO Comment: " + req.body.thinking;
  console.log(largegoal);
  console.log(companystatus);
  console.log(recentcontext);
  console.log(nextaction);
  console.log(actioninput);
  console.log(narrowgoal);
  console.log(thinking);
  updateDatetime();
  fs.writeFileSync(path.join(__dirname, "prompts", "largegoal.txt"), largegoal);
  fs.writeFileSync(
    path.join(__dirname, "prompts", "companystatus.txt"),
    companystatus
  );
  fs.writeFileSync(
    path.join(__dirname, "prompts", "recentcontext.txt"),
    recentcontext
  );
  fs.writeFileSync(
    path.join(__dirname, "prompts", "nextaction.txt"),
    nextaction
  );
  fs.writeFileSync(
    path.join(__dirname, "prompts", "actioninput.txt"),
    actioninput
  );
  fs.writeFileSync(
    path.join(__dirname, "prompts", "narrowgoal.txt"),
    narrowgoal
  );
  fs.writeFileSync(path.join(__dirname, "prompts", "thinking.txt"), thinking);
  try {
    fs.writeFileSync(path.join(__dirname, "prompts", "response.txt"), "");
    const bashScript = path.join(__dirname, "actions", "runcmd.sh");
    const spawnedProcess = spawn(bashScript);

    // Listen to stdout data
    spawnedProcess.stdout.on("data", (data) => {
      console.log(`stdout: ${data}`);
    });

    // Listen to stderr data
    spawnedProcess.stderr.on("data", (data) => {
      console.error(`stderr: ${data}`);
    });

    // Listen to close event
    spawnedProcess.on("close", (code) => {
      console.log(`child process exited with code ${code}`);
      const response = fs.readFileSync(
        path.join(__dirname, "prompts", "response.txt"),
        "utf8"
      );
      res.send(response);

      // Call the next bash script here, inside the 'close' event listener
      try {
        const bashScript = path.join(
          __dirname,
          "actions",
          "assemblepromptandpastetogpt.sh"
        );
        const pasteToGptProcess = spawn(bashScript);
        pasteToGptProcess.stdout.on("data", (data) => {
          console.log(`stdout: ${data}`);
        });
        pasteToGptProcess.stderr.on("data", (data) => {
          console.error(`stderr: ${data}`);
        });
        pasteToGptProcess.on("close", (code) => {
          console.log(`child process exited with code ${code}`);
        });
      } catch (error) {
        console.error(error);
        res.send("CEOGPT Failed to work on this action");
        console.log("I sent CEOGPT Failed to work on this action to the user");
      }
    });
  } catch (error) {
    console.error(error);
    res.send("CEOGPT Failed to work on this action");
    console.log("I sent CEOGPT Failed to work on this action to the user");
  }
});

app.use("/.well-known", express.static(".well-known"));

app.get("/openapi.yaml", (req, res) => {
  const openapiJSON = YAML.load("./openapi.yaml");
  res.json(openapiJSON);
});

app.use("/logo.png", express.static("logo.png"));

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
