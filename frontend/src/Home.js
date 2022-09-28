import React, { useCallback } from 'react';
import './Home.css';
import {Button } from '@material-ui/core';
import { useNavigate } from 'react-router-dom';


function Home() {
    let navigate = useNavigate();
    let routeAdd = useCallback(() => navigate('/Add'), {replace: true}, [navigate]);
    let routeView = useCallback(() => navigate('/View'), {replace: true}, [navigate]);
    let routeQuiz = useCallback(() => navigate('/Quiz'), {replace: true}, [navigate]);
    return (
        <div className="home">
            <h1 class="title">Howdy!</h1>
            <div class = "row1">
                <Button onClick={routeAdd}>Add Records</Button>
                <Button onClick={routeView}>View Records</Button>
                <Button onClick={routeQuiz}>Take Quiz</Button>
            </div>
            <div class = "row2">

            </div>
        </div>
    );
}

export default Home;