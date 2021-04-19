/* My profile page for customers */
import React, { Component } from 'react';
import { Button, Container } from 'react-bootstrap';
// import '../styles/myProfile.css'
const { default: UserServiceApi } = require("../api/UserServiceApi");

class MyProfilePage extends Component {
    render() {
        const userData = UserServiceApi.getLoggedInUserDetails();
        return (
<div class="entire">
  <div class="in-entire">
    <div class="left-cov">
      <div class="profile">
        <div class="human"></div>
      </div>
      <div class="basic">{userData.firstname}<span>{userData.lastname}</span><span class="ball"></span></div>
    </div>
    <div class="right-cov">
      <div class="detail">
        <h3>My Profile</h3>
      </div>
      <div class="full-detail">
        <h4>Email</h4>
        <p>{userData.email}</p>
        <h4>Customer ID</h4>
        <p>{userData.id}</p>
        <p><Button href='/mybookings'>View My Bookings</Button></p>
      </div>
    </div>
  </div>
</div>
        )
    }
}

export default MyProfilePage;
