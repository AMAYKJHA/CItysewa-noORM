import "react-phone-number-input/style.css"
import PhoneInput from "react-phone-number-input";
import { useState } from "react";
import {submitForVerification} from "../../../api/client";

const VerificationForm = () => {
    const [formData, setFromData] = useState({
        id: "",
        phone_number: "",
        document_type: "",
        document_number: "",
        photo: null,
        document: null
    });
    const [error, setError] = useState("");
    const [success, setSuccess] = useState("");
    const handleChange = (e) => {
        const {name, value, files} = e.target;
        setFromData((prev) => ({
            ...prev,
            [name] : files ? files[0] : value
        }));
    };
    const handleSubmit = async (e) => {
        e.preventDefault();
        setError("");
        setSuccess("");
        try{
            const payload = new FormData();
            payload.append("id", formData.id);
            payload.append("phone_number", formData.phone_number);
            payload.append("document_type", formData.document_type);
            payload.append("document_number", formData.document_number);
            payload.append("photo", formData.photo);
            payload.append("document", formData.document);
            await submitForVerification(payload);
            setSuccess("Verification submitted successfully");
            setFromData({id: "", phone_number: "", document_type: "", document_number: "", photo: null, document: null}); 
        } catch(err) {
            setError(err.response?.data?.message || "Submission failed");
            setFromData({id: "", phone_number: "", document_type: "", document_number: "", photo: null, document: null});
        }
    };
    return(
        <form className="verification-form" onSubmit={handleSubmit}>
            <h3>Verify Your Account</h3>
            {error && <p className="error">{error}</p>}
            {success && <p className="success">{success}</p>}
            <span>
                <label htmlFor="provider-id">ID</label>
                <input type="number" id="provider-id" name="id" value={formData.id} onChange={handleChange} required/>
            </span>
            <span>
                <label htmlFor="provider-photo">Upload Your Photo</label>
                <input type="file" id="provider-photo" name="photo" accept=".jpg,.jpeg,.png" onChange={handleChange} required/>
            </span>
            <span>
                <label>Phone Number</label>
                <PhoneInput international defaultCountry="NP" value={formData.phone_number} onChange={(value) => setFromData((prev) => ({...prev, phone_number: value}))} placeholder="Enter phone number"/>
            </span>
            <span>
                <label htmlFor="provider-doc-type">Document Type</label>
                <select id="provider-doc-type" name="document_type" value={formData.document_type} onChange={handleChange} required>
                    <option value={""} hidden disabled>Choose Document Type</option>
                    <option value={"National Id"}>National Id</option>
                    <option value={"Citizenship"}>Citizenship</option>
                    <option value={"Driving Liscense"}>Driving License</option>
                    <option value={"Voter Id"}>Voter Id</option>
                    {/* <option value={"Pan Card"}>Pan Card</option> */}
                </select>
            </span>
            <span>
                <label htmlFor="provider-doc-number">Document Number</label>
                <input type="text" id="provider-doc-number" name="document_number" value={formData.document_number} onChange={handleChange} required/>
            </span>
            <span>
                <label htmlFor="provider-document">Attach Document</label>
                <input type="file" id="provider_document" name="document" accept=".jpg,.jpeg,.png,.pdf" onChange={handleChange} required/>
            </span>
            <button type="submit">Submit</button>
        </form>
    );
};

export default VerificationForm;