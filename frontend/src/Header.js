import React from "react";
import "./Header.css";
import SearchIcon from "@material-ui/icons/Search";
import { Link } from "react-router-dom";

function Header() {
    return (
        <div className="header">
            <Link to="/">
                <img
                    className="icon"
                    src="/img/TAM-Logo.png"
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