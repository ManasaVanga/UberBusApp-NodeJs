/* backend main app file with config */
const express = require("express");
const app = express();
const mongoose = require("mongoose");
// const logger = require("morgan");
const parser = require("body-parser");
const dotenv = require("dotenv");
const passport = require("passport");
const users_routes = require("./api/routes/users");
const locations_routes = require("./api/routes/locations");
const bookings_routes = require("./api/routes/bookings");
const cars_routes = require("./api/routes/cars");
dotenv.config();

// const log4js = require('log4js');
// log4js.configure({
//     appenders: { logs: { type: 'file', filename: '~/log/*log' } },
//     categories: { default: { appenders: ['logs'], level: 'info' } }
// });
// const logger = log4js.getLogger('logs');

// const db_uri = process.env.MONGO_URI || "mongodb+srv://sdileepkumarreddy:Qwerty123@cluster0.j477k.mongodb.net"

const db_uri = "mongodb+srv://admin:Csye7220@uberapp.hvf8i.mongodb.net";
// MongoDB Connection
mongoose
  .connect(db_uri + "/uber?retryWrites=true&w=majority", {
    useUnifiedTopology: true,
    useNewUrlParser: true,
  })
  .then(() => console.log("DB Connected:" + db_uri))
  .catch((err) => {
    console.log(process.env.MONGO_URI);
    console.log("DB Connection Error: " + err.message);
  });
mongoose.Promise = global.Promise;

// simple route
app.get("/test", (req, res) => {
  console.log("Test api call");
  // logger.info("Uber app backend test end point");
  res.json({ message: "Welcome to Uber Bus App Nodejs(Webapp) application." });
});
// app.get("/test", (err, res) => {
//   res.status(200);
//   res.json({ message: "Welcome to Uber Bus App Backend Application" });
//   res.end();
// });
// Logger
// app.use(logger("dev"));

// Parser and set file upload limit
app.use(parser.urlencoded({ limit: "4mb", extended: true }));
app.use(parser.json({ limit: "4mb" }));

// CORS Handling
app.use((req, res, next) => {
  res.header("Access-Control-Allow-Origin", "*");
  res.header(
    "Access-Control-Allow-Headers",
    "Origin, X-Requested-With, Content-Type, Accept, Authorization"
  );
  if (req.method === "OPTIONS") {
    res.header("Access-Control-Allow-Methods", "GET, PUT, POST, PATCH, DELETE");
    return res.status(200).json({});
  }
  next();
});

// Passport Middleware
app.use(passport.initialize());
require("./config/passport")(passport);

// Routes
app.use("/api/users", users_routes);
app.use("/api/locations", locations_routes);
app.use("/api/bookings", bookings_routes);
app.use("/api/cars", cars_routes);

// Error Handling
app.use((req, res, next) => {
  const error = new Error("Not Found");
  error.status = 404;
  next(error);
});
app.use((error, req, res, next) => {
  res.status(error.status || 500);
  res.json({
    error: {
      message: error.message,
      status: error.status,
    },
  });
});

module.exports = app;
