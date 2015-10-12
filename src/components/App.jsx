import React from 'react'
import Config from '../config'
import TimeSheetList from './TimeSheetList.jsx'

class App extends React.Component{
    render() {
        return (
            <div>
                <h1>{Config.title}</h1>
                <TimeSheetList timesheets={this.props.timesheets} />
            </div>
        );
    }
}

export default App
