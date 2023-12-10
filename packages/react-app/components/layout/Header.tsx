import { Disclosure } from "@headlessui/react";
import { Bars3Icon, XMarkIcon, ShoppingCartIcon, WalletIcon } from "@heroicons/react/24/outline";
// Import the AddProductModal and ProductList components
import AddProductModal from "@/components/modal/AddProductModal";
import { ConnectButton } from "@rainbow-me/rainbowkit";
import Image from "next/image";
import Link from "next/link";

export default function Header() {
  return (
    <Disclosure as="nav" className="bg-gray-500 border-b border-black">
      {({ open }) => (
        <>
          <div className="mx-auto max-w-7xl px-2 sm:px-6 lg:px-8">
            <div className="relative flex h-16 justify-between">
              <div className="absolute inset-y-0 left-0 flex items-center sm:hidden">
                {/* Mobile menu button */}
                <Disclosure.Button className="inline-flex items-center justify-center rounded-md p-2 text-black focus:outline-none focus:ring-1 focus:ring-inset focus:rounded-none focus:ring-black">
                  <span className="sr-only">Open main menu</span>
                  {open ? (
                    <XMarkIcon className="block h-6 w-6" aria-hidden="true" />
                  ) : (
                    <Bars3Icon className="block h-6 w-6" aria-hidden="true" />
                  )}
                </Disclosure.Button>
              </div>

              {/* Home and Logo */}
              <div className="flex flex-1 items-center justify-center sm:items-stretch sm:justify-start">
                <div className="flex flex-shrink-0 items-center">
                  <Image
                    className="hidden h-8 w-auto sm:block lg:block"
                    src="/logo.svg"
                    width="24"
                    height="24"
                    alt="Celo Logo"
                  />
                </div>
                <div className="hidden sm:ml-6 sm:flex sm:space-x-8">
                  <Link
                    href="/"
                    className="inline-flex items-center border-b-2 border-black px-1 pt-1 text-sm font-medium text-gray-900 ">
                    <span className="px-6 py-2.5 hover:bg-gray-700 hover:shadow-lg focus:bg-gray-700 focus:shadow-lg focus:outline-none focus:ring-0 active:bg-gray-800 active:shadow-lg transition duration-150 ease-in-out">Marketplace</span>
                  </Link>
                  <Link
                    href="/yourproducts"
                    className="inline-flex items-center border-b-2 border-black px-1 pt-1 text-sm font-medium text-gray-900 ">
                    <span className="px-6 py-2.5 hover:bg-gray-700 hover:shadow-lg focus:bg-gray-700 focus:shadow-lg focus:outline-none focus:ring-0 active:bg-gray-800 active:shadow-lg transition duration-150 ease-in-out">Your Products</span>
                  </Link>
                </div>
              </div>

              {/* Connect Button */}
              <div className="absolute inset-y-0 right-0 flex items-center pr-2 sm:static sm:inset-auto sm:ml-6 sm:pr-0 sm:flex sm:space-x-4 ">
                <div>
                  {/* <ConnectButton
                  showBalance={{ smallScreen: true, largeScreen: false }}
                /> */}
                  <ConnectButton.Custom>
                    {({
                      account,
                      chain,
                      openAccountModal,
                      openChainModal,
                      openConnectModal,
                      authenticationStatus,
                      mounted,
                    }) => {
                      // Note: If your app doesn't use authentication, you
                      // can remove all 'authenticationStatus' checks
                      const ready = mounted && authenticationStatus !== 'loading';
                      const connected =
                        ready &&
                        account &&
                        chain &&
                        (!authenticationStatus ||
                          authenticationStatus === 'authenticated');

                      return (
                        <div
                          {...(!ready && {
                            'aria-hidden': true,
                            'style': {
                              opacity: 0,
                              pointerEvents: 'none',
                              userSelect: 'none',
                            },
                          })}
                        >
                          {(() => {
                            if (!connected) {
                              return (
                                <button onClick={openConnectModal} type="button" className="bg-neutral-950 px-4 py-2 rounded-lg shadow-md text-gray-300  hover:bg-neutral-700">
                                  Connect Wallet
                                </button>
                              );
                            }

                            if (chain.unsupported) {
                              return (
                                <button onClick={openChainModal} type="button" className="bg-red-600 px-4 py-2 rounded-lg shadow-md text-green-100">
                                  Wrong network
                                </button>
                              );
                            }

                            return (
                              <div style={{ display: 'flex', gap: 12 }}>
                                <button
                                  onClick={openChainModal}
                                  style={{ display: 'flex', alignItems: 'center' }}
                                  type="button"
                                  className="bg-neutral-950 px-4 py-2 text-green-300 rounded-lg shadow-md hover:bg-neutral-800 font-bold"
                                >
                                  {chain.hasIcon && (
                                    <div
                                      style={{
                                        background: chain.iconBackground,
                                        width: 20,
                                        height: 20,
                                        borderRadius: 999,
                                        overflow: 'hidden',
                                        marginRight: 4,
                                      }}
                                    >
                                      {chain.iconUrl && (
                                        <Image
                                          width={20}
                                          height={20}
                                          alt={chain.name ?? 'Chain icon'}
                                          src={chain.iconUrl}
                                        />
                                      )}
                                    </div>
                                  )}
                                  {chain.name}

                                </button>

                                <button onClick={openAccountModal} type="button" className="bg-neutral-950 px-4 py-2 text-gray-500 rounded-lg shadow-md hover:bg-neutral-800 font-bold">
                                  {account.displayName}
                                </button>
                              </div>
                            );
                          })()}
                        </div>
                      );
                    }}
                  </ConnectButton.Custom>
                </div>
              </div>
            </div>
          </div>

          <Disclosure.Panel className="sm:hidden">
            <div className="space-y-1 pt-2 pb-4">
              <Disclosure.Button
                as="a"
                href="#"
                className="block border-l-4 border-black py-2 pl-3 pr-4 text-base font-medium text-black">
                Home
              </Disclosure.Button>
              <Disclosure.Button
                as="a"
                href="#"
                className="block border-l-4 border-black py-2 pl-3 pr-4 text-base font-medium text-black">
                Add Orders
              </Disclosure.Button>
              {/* Add here your custom menu elements */}
            </div>
          </Disclosure.Panel>
        </>
      )}
    </Disclosure>
  );
}
