import React from 'react'
import ReactDOM from 'react-dom'
import { createStore, combineReducers } from 'redux'
import TimeSheetList from './TimeSheetList.jsx'

class App extends React.Component {
    render() {
        return (
            <h1>Hi</h1>
        );
    }
}

ReactDOM.render(<App />, document.getElementById('root'));