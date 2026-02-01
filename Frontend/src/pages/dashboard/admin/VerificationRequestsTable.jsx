import { useEffect, useState } from "react";
import { fetchVerificationData} from "../../../api/client";

const VerificationRequests = () => {

    const [requests, setrequests] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [searchBy, setSearchBy] = useState("Id");
    const [shownIndex, setShownIndex] = useState(0);
    const PAGE_SIZE = 10;
    const requestsOnDisplay = requests.slice(shownIndex, shownIndex + PAGE_SIZE);
    // Functions that show records on the table
    const showNextBatch = () => {
        setShownIndex(prev => prev + PAGE_SIZE < requests.length ? prev + PAGE_SIZE : prev);
    };
    const showPrevBatch = () => {
        setShownIndex(prev => prev - PAGE_SIZE >= 0 ? prev - PAGE_SIZE : 0);
    };

    const handleChange = (e) => {
        setSearchBy(e.target.value);
    };

    useEffect(()=>{
        const loadrequests = async () => {
            try{
                const response = await fetchVerificationData();
                
                const sortedrequests = response.data.slice().sort((a,b)=> a.id - b.id);
                setrequests(sortedrequests);
            } catch (e) {
                setError("Failed to fetch requests");
                console.error(e);
            } finally {
                setLoading(false);
            }
        };
        loadrequests();
    }, []);

    if (loading) return <p>Loading requests ...</p>;
    if (error) return <p>{error}</p>

    return(
        <section className="verification-requests">
            <h2>Verification Requests</h2>
            {/* <input type="text" placeholder={`Search by ${searchBy}`}/>
            <select value={searchBy} name="searchBy" onChange={handleChange}>
                <option disabled hidden value={""}>Search by</option>
                <option value={"Id"}>Id</option>
                <option value={"First Name"}>First Name</option>
                <option value={"Last Name"}>Last Name</option>
            </select> */}
            {requests.length === 0 ? 
            ( <p> No requests at the moment </p>) :
            ( <p> There are some requests you would like to review</p>)
            }
            <table>
                <thead>
                    <tr>
                        <th>Id</th>
                        <th>Phone Number</th>
                        <th>Document Type</th>
                        <th>Document Number</th>
                        <th>Photo</th>
                        <th>Document</th>
                    </tr>
                </thead>
                <tbody>
                    {requestsOnDisplay.map(req => (
                        <tr key={req.id}>
                            <td>{req.id}</td>
                            <td>{req.phone_number}</td>
                            <td>{req.document_type}</td>
                            <td>{req.document_number}</td>
                            <td><a href={req.photo} target="_blank" rel="noreferrer">View Photo</a></td>
                            <td><a href={req.document} target="_blank" rel="noreferrer">View Document</a></td>
                        </tr>
                    ))}
                </tbody>  
            </table>
            <span style={{display:'flex', flexDirection:'row', justifyContent:'space-evenly',marginTop:'8px'}}><p style={{opacity: shownIndex === 0 ? '0.5' : '1'}} onClick={showPrevBatch}>Prev</p><p style={{opacity: shownIndex + PAGE_SIZE >= requests.length ? '0.5' : '1'}} onClick={showNextBatch}>Next</p></span>
        </section>
    );
};

export default VerificationRequests;