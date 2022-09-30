import "./table.css"

let data = [
    { image: "", name: "John Doe", email: "jdoe@tamu.edu", courses: "CSCE 101", tags: "good student"},
    { image: "", name: "Jane Doe", email: "j_doe@tamu.edu", courses: "CSCE 101", tags: "good student"},
    { image: "", name: "Juniper Smith", email: "jsmith@tamu.edu", courses: "CSCE 101", tags: "good student"},
]

function Table() {
    return (
        <div className="table">
            <table>
                <tr>
                    <th>Image</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Courses</th>
                    <th>Tags</th>
                </tr>
                {data.map((item) => (
                    <tr>
                        <td>{item.image}</td>
                        <td>{item.name}</td>
                        <td>{item.email}</td>
                        <td>{item.courses}</td>
                        <td>{item.tags}</td>
                    </tr>
                ))}
            </table>
        </div>
    );
}

export default Table;