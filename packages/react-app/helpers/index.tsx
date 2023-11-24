import Blockies from "react-blockies";
import { BigNumber } from "ethers";

export const identiconTemplate = (address: string) => {
  return (
    <Blockies
      size={14} // number of pixels square
      scale={4} // width/height of each 'pixel'
      className="identicon border-2 border-white rounded-full" // optional className
      seed={address} // seed used to generate icon data, default: random
    />
  );
};

export type Product = {
  id: number;
  name: string;
  price: BigNumber;
  owner: string;
  image: string;
  description: string;
  location: string;
  sold: boolean;
};
