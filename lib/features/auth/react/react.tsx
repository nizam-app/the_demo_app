import { useState } from "react";
import { ChevronLeft, Edit } from "lucide-react";
import imgImage from "figma:asset/640095c1e2580179fc9edafad66ad6a0fad6d9ca.png";

export default function ProfileScreen() {
  const [rolesEnabled, setRolesEnabled] = useState(true);
  const [remoteAccessEnabled, setRemoteAccessEnabled] = useState(true);

  return (
    <div className="bg-[#f3f4f6] min-h-screen w-[430px] h-[932px] mx-auto relative overflow-y-auto">
      {/* Status Bar */}
      <div className="pt-[26px] px-[32px] pb-[15px]">
        <p className="font-['Roboto'] font-medium text-[14px] text-[#111827]">
          9:41
        </p>
      </div>

      {/* Header */}
      <div className="px-[17px] mb-[15px]">
        <div className="flex items-center justify-between">
          <button className="w-[32px] h-[32px] bg-white rounded-full flex items-center justify-center">
            <ChevronLeft className="w-[16px] h-[16px] text-[#111827]" />
          </button>
          <h1 className="font-['Inter'] font-semibold text-[22px] text-[#111827]">
            Profile
          </h1>
          <button className="w-[32px] h-[32px] bg-white rounded-full flex items-center justify-center">
            <Edit className="w-[16px] h-[16px] text-[#111827]" />
          </button>
        </div>
      </div>

      {/* Profile Card */}
      <div className="mx-[14px] mb-[24px] bg-white rounded-[26px] p-[20px] flex items-center gap-[16px]">
        <div className="w-[68px] h-[68px] rounded-full overflow-hidden flex-shrink-0">
          <img
            src={imgImage}
            alt="Profile"
            className="w-full h-full object-cover"
          />
        </div>
        <div className="flex-1">
          <h2 className="font-['Inter'] font-normal text-[21px] text-[#111827] mb-[4px]">
            Oren Elimelech
          </h2>
          <p className="font-['Inter'] font-normal text-[16px] text-[#6b7280] mb-[8px]">
            oren@aican.co.il
          </p>
          <span className="inline-block bg-[#00d1ff] text-white font-['Inter'] font-medium text-[14px] px-[16px] py-[4px] rounded-[5px]">
            Cloud
          </span>
        </div>
      </div>

      {/* Information Section */}
      <div className="px-[14px] mb-[24px]">
        <h3 className="font-['Inter'] font-semibold text-[20px] text-[#111827] mb-[16px] px-[6px]">
          Information
        </h3>
        <div className="bg-white rounded-[26px] py-[16px]">
          {/* Name */}
          <div className="px-[20px] py-[10px]">
            <div className="flex justify-between items-center">
              <span className="font-['Inter'] font-normal text-[16px] text-[#6b7280]">
                Name
              </span>
              <span className="font-['Inter'] font-normal text-[16px] text-[#111827]">
                Oren Elimelech
              </span>
            </div>
          </div>
          <div className="h-[1px] bg-[#e1e1e1] mx-[20px]" />

          {/* Email */}
          <div className="px-[20px] py-[10px]">
            <div className="flex justify-between items-center">
              <span className="font-['Inter'] font-normal text-[16px] text-[#6b7280]">
                Email
              </span>
              <span className="font-['Inter'] font-normal text-[16px] text-[#111827]">
                oren@aican.co.il
              </span>
            </div>
          </div>
          <div className="h-[1px] bg-[#e1e1e1] mx-[20px]" />

          {/* Phone */}
          <div className="px-[20px] py-[10px]">
            <div className="flex justify-between items-center">
              <span className="font-['Inter'] font-normal text-[16px] text-[#6b7280]">
                Phone
              </span>
              <span className="font-['Inter'] font-normal text-[16px] text-[#111827]">
                0547640189
              </span>
            </div>
          </div>
          <div className="h-[1px] bg-[#e1e1e1] mx-[20px]" />

          {/* Address */}
          <div className="px-[20px] py-[10px]">
            <div className="flex justify-between items-center">
              <span className="font-['Inter'] font-normal text-[16px] text-[#6b7280]">
                Address
              </span>
              <span className="font-['Inter'] font-normal text-[16px] text-[#111827]">
                Margalit 54 Shoham Israel
              </span>
            </div>
          </div>
          <div className="h-[1px] bg-[#e1e1e1] mx-[20px]" />

          {/* Categories */}
          <div className="px-[20px] py-[10px]">
            <div className="flex justify-between items-center">
              <span className="font-['Inter'] font-normal text-[16px] text-[#6b7280]">
                Categories
              </span>
              <span className="font-['Inter'] font-normal text-[16px] text-[#111827]">
                Electrician
              </span>
            </div>
          </div>
        </div>
      </div>

      {/* Account Section */}
      <div className="px-[14px] mb-[24px]">
        <h3 className="font-['Inter'] font-semibold text-[20px] text-[#111827] mb-[16px] px-[6px]">
          Account
        </h3>
        <div className="bg-white rounded-[26px] py-[16px]">
          {/* Email */}
          <div className="px-[20px] py-[10px]">
            <div className="flex justify-between items-center">
              <span className="font-['Inter'] font-normal text-[16px] text-[#6b7280]">
                Email
              </span>
              <span className="font-['Inter'] font-normal text-[16px] text-[#111827]">
                oren@aican.co.il
              </span>
            </div>
          </div>
          <div className="h-[1px] bg-[#e1e1e1] mx-[20px]" />

          {/* Password */}
          <div className="px-[20px] py-[10px]">
            <div className="flex justify-between items-center">
              <span className="font-['Inter'] font-normal text-[16px] text-[#6b7280]">
                Password
              </span>
              <span className="font-['Inter'] font-normal text-[16px] text-[#111827]">
                *****************
              </span>
            </div>
          </div>
          <div className="h-[1px] bg-[#e1e1e1] mx-[20px]" />

          {/* Roles */}
          <div className="px-[20px] py-[10px]">
            <div className="flex justify-between items-center">
              <span className="font-['Inter'] font-normal text-[16px] text-[#6b7280]">
                Roles
              </span>
              <button
                onClick={() => setRolesEnabled(!rolesEnabled)}
                className="relative w-[32px] h-[32px] flex items-center justify-center"
              >
                <div
                  className={`w-[32px] h-[32px] rounded-full transition-colors ${
                    rolesEnabled ? "bg-[#0088fe]" : "bg-[#e1e1e1]"
                  }`}
                >
                  <div className="w-full h-full flex items-center justify-center">
                    <div className="w-[20px] h-[20px] bg-white rounded-full" />
                  </div>
                </div>
              </button>
            </div>
          </div>
          <div className="h-[1px] bg-[#e1e1e1] mx-[20px]" />

          {/* Remote Access */}
          <div className="px-[20px] py-[10px]">
            <div className="flex justify-between items-center">
              <span className="font-['Inter'] font-normal text-[16px] text-[#6b7280]">
                Remote access
              </span>
              <button
                onClick={() => setRemoteAccessEnabled(!remoteAccessEnabled)}
                className="relative w-[60px] h-[35px] rounded-[30px] transition-colors"
                style={{
                  backgroundColor: remoteAccessEnabled ? "#0088fe" : "#e1e1e1",
                }}
              >
                <div
                  className="absolute top-[2px] w-[31px] h-[31px] bg-white rounded-full transition-all"
                  style={{
                    left: remoteAccessEnabled ? "27px" : "2px",
                  }}
                />
              </button>
            </div>
          </div>
        </div>
      </div>

      {/* Connect Section */}
      <div className="px-[14px] mb-[24px]">
        <h3 className="font-['Inter'] font-semibold text-[20px] text-[#111827] mb-[16px] px-[6px]">
          Connect
        </h3>
        <div className="bg-white rounded-[26px] p-[16px]">
          <div className="flex items-center gap-[24px]">
            {/* Apple */}
            <div className="flex items-center gap-[12px]">
              <div className="w-[50px] h-[50px] bg-[#f3f4f6] rounded-full flex items-center justify-center">
                <svg width="32" height="32" viewBox="0 0 32 32" fill="none">
                  <path
                    d="M25.8 17.2c0-3.3 2.7-4.9 2.8-5-1.5-2.2-3.9-2.5-4.7-2.5-2-0.2-3.9 1.2-4.9 1.2-1 0-2.5-1.2-4.2-1.1-2.1 0-4.1 1.2-5.2 3.1-2.2 3.8-0.6 9.5 1.6 12.6 1.1 1.5 2.3 3.2 4 3.1 1.6-0.1 2.2-1 4.2-1 2 0 2.5 1 4.2 1 1.7 0 2.8-1.5 3.9-3 1.2-1.7 1.7-3.4 1.7-3.5-0.1 0-3.2-1.2-3.4-4.9zM22.3 8.1c0.9-1.1 1.5-2.6 1.3-4.1-1.3 0.1-2.8 0.9-3.7 1.9-0.8 0.9-1.5 2.4-1.3 3.8 1.4 0.1 2.8-0.7 3.7-1.6z"
                    fill="#111827"
                  />
                </svg>
              </div>
              <span className="font-['Inter'] font-normal text-[16px] text-[#111827]">
                Apple
              </span>
              <span className="font-['Inter'] font-extralight text-[36px] text-[#111827] leading-none">
                +
              </span>
            </div>

            {/* Google */}
            <div className="flex items-center gap-[12px]">
              <div className="w-[50px] h-[50px] bg-[#f3f4f6] rounded-full flex items-center justify-center">
                <svg width="30" height="30" viewBox="0 0 30 30" fill="none">
                  <path
                    d="M28.5 15.3c0-1-.1-2-.2-2.9H15v5.5h7.6c-.3 1.7-1.3 3.1-2.8 4v3.6h4.5c2.6-2.4 4.2-6 4.2-10.2z"
                    fill="#4285F4"
                  />
                  <path
                    d="M15 29c3.8 0 7-1.2 9.3-3.3l-4.5-3.6c-1.3.9-2.9 1.4-4.8 1.4-3.7 0-6.8-2.5-7.9-5.9H2.4v3.7C4.7 26.1 9.5 29 15 29z"
                    fill="#34A853"
                  />
                  <path
                    d="M7.1 17.6c-.6-1.7-.6-3.6 0-5.3V8.6H2.4C.3 12.7.3 17.3 2.4 21.3l4.7-3.7z"
                    fill="#FBBC04"
                  />
                  <path
                    d="M15 6.5c2.1 0 4 .7 5.5 2.1l4.1-4.1C22 2.1 18.7.8 15 .8c-5.5 0-10.3 2.9-12.6 7.8l4.7 3.7c1.1-3.4 4.2-5.9 7.9-5.9z"
                    fill="#EA4335"
                  />
                </svg>
              </div>
              <span className="font-['Inter'] font-normal text-[16px] text-[#111827]">
                Google
              </span>
              <span className="font-['Inter'] font-extralight text-[36px] text-[#111827] leading-none">
                +
              </span>
            </div>
          </div>
        </div>
      </div>

      {/* Update Account Button */}
      <div className="px-[30px] pb-[40px]">
        <button className="w-full h-[55px] bg-white border border-[#0088fe] rounded-[26px] flex items-center justify-center gap-[8px]">
          <svg width="18" height="18" viewBox="0 0 18 18" fill="none">
            <path
              d="M15.75 7.5V6c0-2.07-1.68-3.75-3.75-3.75h-6C3.93 2.25 2.25 3.93 2.25 6v6c0 2.07 1.68 3.75 3.75 3.75h1.5"
              stroke="#0088fe"
              strokeWidth="1.5"
              strokeLinecap="round"
              strokeLinejoin="round"
              fill="none"
            />
            <path
              d="M10.5 7.5l5.25 5.25M10.5 12.75v-5.25h5.25"
              stroke="#0088fe"
              strokeWidth="1.5"
              strokeLinecap="round"
              strokeLinejoin="round"
              fill="none"
            />
          </svg>
          <span className="font-['Inter'] font-semibold text-[16px] text-[#0088fe]">
            Update Account
          </span>
        </button>
      </div>
    </div>
  );
}