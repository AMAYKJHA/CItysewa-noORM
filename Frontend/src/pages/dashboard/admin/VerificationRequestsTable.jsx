import { useEffect, useState } from "react";
import { fetchVerificationData, fetchVerificationDataById, updateVerificationData} from "../../../api/client";

const VerificationRequests = () => {

    const [requests, setrequests] = useState([]);
    const [loading, setLoading] = useState(true);
    const [errorInMultipleDataFetch, setErrorForMultipleDataFetch] = useState(null);
    const [errorInSingleDataFetch, setErrorForSingleDataFetch] = useState(null);
    const [searchBy, setSearchBy] = useState("Id");
    const [shownIndex, setShownIndex] = useState(0);
    const PAGE_SIZE = 10;
    const requestsOnDisplay = requests.slice(shownIndex, shownIndex + PAGE_SIZE);
    const [selectedRequest, setSelectedRequest] = useState(null);
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

    const handleClick = async (id) => {
        try{
            const response = await fetchVerificationDataById(id);
            setSelectedRequest(response.data);
            console.log(response);
        } 
        catch(err) {
            setErrorForSingleDataFetch("Failed to fetch request");
        }
    }

    const handleClose = () => {
        setSelectedRequest(null);
    };

    const updateVerificationStatus = async (ver_status) => {
        try{
            if(!selectedRequest) return;
            const patchData = {
                document_number: selectedRequest.document_number,
                status: ver_status,
                verified: ver_status === "Verified"
            }
            await updateVerificationData(selectedRequest.id, patchData);
            await loadrequests();
            handleClose();
            console.log("Updated provider verification status as : "+ver_status);
        } catch(err) {
            console.error("Error updating provider:", err.response?.data || err.message);
        }
    };

    const loadrequests = async () => {
        try{
            const response = await fetchVerificationData();
            const sortedrequests = response.data.slice().sort((a,b)=> a.id - b.id);
            setrequests(sortedrequests);
        } catch (e) {
            setErrorForMultipleDataFetch("Failed to fetch requests");
            console.error(e);
        }
    };

    useEffect(()=>{
        const load = async () => {
            await loadrequests();
            setLoading(false);
        };
        load();
    }, []);

    useEffect(()=>{
        if(errorInSingleDataFetch){
            alert("Failed to fetch response");
            setErrorForSingleDataFetch(null);
        }
    },[errorInSingleDataFetch])

    if (loading) return <p>Loading requests ...</p>;
    if (errorInMultipleDataFetch) return <p>{errorInMultipleDataFetch}</p>

    return(
        <>
            {selectedRequest? (
                <section className="VRD-container">
                    <h2>Provider Details</h2>
                    <div className="verify-request-data">
                        <a href={selectedRequest.photo} target="_blank" rel="noreferrer"><img src={selectedRequest.photo} alt={"Provider PP"}/></a>
                        <p><strong>Id: </strong>{selectedRequest.id}</p>
                        <p><strong>Name: </strong>{selectedRequest.first_name+" "+selectedRequest.last_name}</p>
                        <p><strong>Gender: </strong>{selectedRequest.gender}</p>
                        <p><strong>Phone Number: </strong>{selectedRequest.phone_number || "Amay le rakheko xaina"}</p>
                        <p><strong>Provided Document Type: </strong>{selectedRequest.document_type}</p>
                        <p><strong>Document Number: </strong>{selectedRequest.document_number}</p>
                        <p><strong>Document: </strong><a href={selectedRequest.file_name} target="_blank" rel="noreferrer"><img src={selectedRequest.file_name} alt={"Provider Document"}/></a></p>
                        <p><strong>Is Verified: </strong>{selectedRequest.verified ? "Yes" : "No"}</p>
                        <p><strong>Verification Status: </strong>{selectedRequest.status}</p>
                    </div>
                    <span style={{display:'flex', flexDirection:'row', justifyContent:'space-evenly', marginTop:'13px'}}>
                        <button onClick={()=>updateVerificationStatus("Verified")}>Verify</button>
                        <button onClick={()=>updateVerificationStatus("Not verified")}>Unverify</button>
                        <button onClick={handleClose}>Close</button>
                    </span>
                </section>
            ): ""} 
            <section className="verification-requests">
            <h2>Verification Requests</h2>
            <input type="text" placeholder={`Search by ${searchBy}`}/>
            <select value={searchBy} name="searchBy" onChange={handleChange}>
                <option disabled hidden value={""}>Search by</option>
                <option value={"Id"}>Id</option>
                <option value={"First Name"}>First Name</option>
                <option value={"Last Name"}>Last Name</option>
            </select>
            <div className="tablewrapper">
                <table>
                    <thead>
                        <tr>
                            <th>Id</th>
                            <th>Name</th>
                            <th>Phone Number</th>
                            <th>Document Type</th>
                            <th>Document Number</th>
                            <th>Photo</th>
                            <th>Document</th>
                        </tr>
                    </thead>
                    <tbody>
                        {requestsOnDisplay.map(req => (
                            <tr key={req.id} onClick={()=>handleClick(req.id)}>
                                <td>{req.id}</td>
                                <td>{req.first_name+" "+req.last_name}</td>
                                <td>View Number</td>
                                <td>View Doctype</td>
                                <td>View Doc. No.</td>
                                <td>View Photo</td>
                                <td>View Document</td>
                            </tr>
                        ))}
                    </tbody>  
                </table>
            </div>
            {requests.length === 0 ? 
            ( <p style={{marginLeft:'8px'}}> No requests at the moment </p>) :
            ( <p></p>)
            }
            <span style={{display:'flex', flexDirection:'row', justifyContent:'space-evenly',marginTop:'8px'}}><p style={{opacity: shownIndex === 0 ? '0.5' : '1'}} onClick={showPrevBatch}>Prev</p><p style={{opacity: shownIndex + PAGE_SIZE >= requests.length ? '0.5' : '1'}} onClick={showNextBatch}>Next</p></span>
        </section>   
        </>
    );
};

export default VerificationRequests;