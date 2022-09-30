import React from "react";
import "./Header.css";
import SearchIcon from "@material-ui/icons/Search";
import { Link } from "react-router-dom";
import TAMU_Logo from './img/TAM-Logo.png'

function Header() {
    return (
        <div className="header">
            <Link to="/">
                <img
                    className="icon"
                    src={TAMU_Logo}
                    alt="TAMU Logo"
                />
            </Link>
        
            <div className="searchbar">
                <input type="text" />
                <SearchIcon />
            </div>
        </div>
    );
}

export default Header;