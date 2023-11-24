// This component is used to display all the products in the marketplace

// Importing the dependencies
import { useState } from "react";
// Import the useAccount hook to get the user's address
import { useAccount } from "wagmi";
import { BigNumber } from "ethers";
// Import the useContractCall hook to read how many products are in the marketplace via the contract
import { useContractCall } from "@/hooks/contract/useContractRead";
// Import the Product and Alert components
import UserProduct from "./UserProduct"; "@/components/UserProduct";
// Define the ProductList component
const UserProductList = () => {
    // Use the useAccount hook to store the user's address
    const { address } = useAccount();
    // Use the useContractCall hook to read how many products are in the marketplace contract
    const { data } = useContractCall("getUserItem", [address], true);
    // Convert the data to a number

    const userProduct = data ? (data as Array<BigNumber>) : [];

    // Define the states to store the error, success and loading messages
    const [error, setError] = useState("");
    const [success, setSuccess] = useState("");
    const [loading, setLoading] = useState("");

    // Define a function to clear the error, success and loading states
    const clear = () => {
        setError("");
        setSuccess("");
        setLoading("");
    };

    // Define a function to return the products
    const getProducts = () => {
        // If there are no products, return null
        if (userProduct.length == 0) return null;

        // define product components is an empty array
        const productComponents: JSX.Element[] | null = [];

        for (let i = 0; i < userProduct.length; i++) {
            productComponents.push(
                <UserProduct
                    key={userProduct[i]}
                    id={userProduct[i]}
                    setSuccess={setSuccess}
                    setError={setError}
                    setLoading={setLoading}
                    loading={loading}
                    clear={clear}

                />
            );
        }
        return productComponents;
    };

    // Return the JSX for the component
    return (
        <div className="flex-col">
            {/* Display the products */}
            <div className="mx-auto my-5 max-w-2xl px-4 sm:px-6 lg:max-w-7xl lg:px-8 ">
                <div className="grid grid-cols-1 gap-y-10 gap-x-6 sm:grid-cols-2 lg:grid-cols-3 xl:gap-x-8">
                    {/* Loop through the products and return the Product component */}
                    {getProducts()}
                </div>
            </div>
        </div>
    );
};

export default UserProductList;
