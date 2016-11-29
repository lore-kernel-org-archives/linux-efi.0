From: "Baicar, Tyler" <tbaicar@codeaurora.org>
Subject: Re: [PATCH V5 03/10] efi: parse ARMv8 processor error
Date: Tue, 29 Nov 2016 08:37:53 -0700
Message-ID: <b2a957b5-bf3b-f12c-ecba-28ddd97cb84f@codeaurora.org>
References: <1479767763-27532-1-git-send-email-tbaicar@codeaurora.org>
 <1479767763-27532-4-git-send-email-tbaicar@codeaurora.org>
 <58388193.6000202@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <58388193.6000202@arm.com>
Sender: kvm-owner@vger.kernel.org
To: James Morse <james.morse@arm.com>
Cc: marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, lenb@kernel.org, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, nkaje@codeaurora.org, zjzhang@codeaurora.org, mark.rutland@arm.com, akpm@linux-foundation.org, eun.taik.lee@samsung.com, sandeepa.s.prabhu@gmail.com, shijie.huang@arm.com, rruigrok@codeaurora.org, paul.gortmaker@windriver.com, tomasz.nowicki@linaro.org, fu.wei@linaro.org, rostedt@goodmis.org, bristot@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, Suzuki.Poulose@arm.com, punit.agrawal@arm.com, astone@redhat.com
List-Id: linux-efi@vger.kernel.org

Hello James,

On 11/25/2016 11:23 AM, James Morse wrote:
> Hi Tyler,
>
> On 21/11/16 22:35, Tyler Baicar wrote:
>> Add support for ARMv8 Common Platform Error Record (CPER).
>> UEFI 2.6 specification adds support for ARMv8 specific
>> processor error information to be reported as part of the
>> CPER records. This provides more detail on for processor error logs.
> I think I'm missing a big part of the puzzle here, I will come back to this next
> week. I can't quite line up some of the masks and shifts with the table
> descriptions in the UEFI spec[0].

It looks like there was some misunderstanding when the context info 
parsing was added here
(probably because the spec has some issues that I describe below).
I'll need to clean quite a bit of the context info parsing up. I didn't 
catch this earlier because
we aren't reporting context info in firmware right now for the errors I 
have been testing.

>> diff --git a/include/linux/cper.h b/include/linux/cper.h
>> index 13ea41c..2a9d553 100644
>> --- a/include/linux/cper.h
>> +++ b/include/linux/cper.h
>> @@ -180,6 +185,10 @@ enum {
>>   #define CPER_SEC_PROC_IPF						\
>>   	UUID_LE(0xE429FAF1, 0x3CB7, 0x11D4, 0x0B, 0xCA, 0x07, 0x00,	\
>>   		0x80, 0xC7, 0x3C, 0x88, 0x81)
>> +/* Processor Specific: ARMv8 */
>> +#define CPER_SEC_PROC_ARMV8						\
>> +	UUID_LE(0xE19E3D16, 0xBC11, 0x11E4, 0x9C, 0xAA, 0xC2, 0x05,	\
>> +		0x1D, 0x5D, 0x46, 0xB0)
> Nit: UEFI v2.6 N.2.2 (table 249) describes this as 'ARM' not 'ARMV8' (which is
> an architectural version).

I'll change it in the next set.

>>   /* Platform Memory */
>>   #define CPER_SEC_PLATFORM_MEM						\
>>   	UUID_LE(0xA5BC1114, 0x6F64, 0x4EDE, 0xB8, 0x63, 0x3E, 0x83,	\
>> @@ -255,6 +264,34 @@ enum {
>>   
>>   #define CPER_PCIE_SLOT_SHIFT			3
>>   
>> +#define CPER_ARMV8_ERR_INFO_NUM_MASK		0x00000000000000FF
>> +#define CPER_ARMV8_CTX_INFO_NUM_MASK		0x0000000000FFFF00
> Table 260 describes both ERR_INFO_NUM and CONTEXT_INFO_NUM for as both being
> 2bytes long, as does your struct cper_sec_proc_armv8 below. Are these for
> something else? Do these correspond with one of the four bitfield formats
> described in Table 262->265?
>
> I can't see where they are used, and they look like they are reaching across
> multiple fields in a struct.

I will remove these as they aren't needed.

>> +#define CPER_ARMV8_CTX_INFO_NUM_SHIFT		8
>> +
>> +#define CPER_ARMV8_VALID_MPIDR			0x00000001
>> +#define CPER_ARMV8_VALID_AFFINITY_LEVEL		0x00000002
>> +#define CPER_ARMV8_VALID_RUNNING_STATE		0x00000004
>> +#define CPER_ARMV8_VALID_VENDOR_INFO		0x00000008
>> +
>> +#define CPER_ARMV8_INFO_VALID_MULTI_ERR		0x0001
>> +#define CPER_ARMV8_INFO_VALID_FLAGS		0x0002
>> +#define CPER_ARMV8_INFO_VALID_ERR_INFO		0x0004
>> +#define CPER_ARMV8_INFO_VALID_VIRT_ADDR		0x0008
>> +#define CPER_ARMV8_INFO_VALID_PHYSICAL_ADDR	0x0010
>> +
>> +#define CPER_ARMV8_INFO_FLAGS_FIRST		0x0001
>> +#define CPER_ARMV8_INFO_FLAGS_LAST		0x0002
>> +#define CPER_ARMV8_INFO_FLAGS_PROPAGATED	0x0004
>> +
>> +#define CPER_AARCH64_CTX_LEN			368
>> +#define CPER_AARCH32_CTX_LEN			256
> Are these the worst case sizes for combinations of the structures in N2.4.4.2?
> (Tables 266 to 273)
>
> If so is there any chance they could be sizeof(<some union of structs>), even if
> the structs are things like:
>> /* ARMv8 AArch64 GPRs (Type 4) - defined in UEFI Spec N2.4.4.2 */
>> struct cper_armv8_aarch64_gprs {
>> 	u64 regs[32];
>> }
> This way its easier to check the number is correct, and if a new type is added
> this won't get forgotten.

These were representing the sizes of table 266 and table 267, but 
looking at this more it seems
like some of the spec doesn't make sense:

Table 260 has the Processor Context field which only mentions tables 266 
and 267.
I think that should really be tables 266 - 274 representing all 9 
context types.

Table 265 then has the Register Array field which mentions the contents 
of the array
are described in tables 267 - 271. I think this also should be tables 
266 - 274 to cover
all 9 context types.

And then the text before table 274 is clearly wrong calling it table 
275...seems like there
are several mistakes in the table numbering mentioned in this section.

I'm going to need to update the context info parsing code and add the 
other register array
sizes based on all of the context tables. Looks like the code will need 
to be restructured
some because otherwise there will be quite a bit of duplication.

>> +#define CPER_ARMV8_CTX_TYPE_MASK		0x000000000000000F
>> +#define CPER_ARMV8_CTX_EL_MASK			0x0000000000000070
>> +#define CPER_ARMV8_CTX_NS_MASK			0x0000000000000080
>> +#define CPER_ARMV8_CTX_EL_SHIFT			4
>> +#define CPER_ARMV8_CTX_NS_SHIFT			7
>> +
> Again, I can't work out what these correspond to. I can't see a secure bit or EL
> field in any of those UEFI tables.
>
> Is this one of the 'ARM Vendor Specific Micro-Architecture Error Structure's? If
> so we should have some infrastructure for picking the correct (or unknown)
> decode function based on a range of MIDRs.

These will be removed. The exception level and secure context 
information will be covered by
which register context type is being reported.

0 – AArch32 GPRs (General Purpose Registers).
1 -- AArch32 EL1 context registers
2 -- AArch32 EL2 context registers
3 -- Aarch32 secure context registers
4 – AArch64 GPRs
5 -- AArch64 EL1 context registers
6 – Aarch64 EL2 context registers
7 -- AArch64 EL3 context registers
8 – Misc. System Register Structure

>>   #define acpi_hest_generic_data_error_length(gdata)	\
>>   	(((struct acpi_hest_generic_data *)(gdata))->error_data_length)
>>   #define acpi_hest_generic_data_size(gdata)		\
>> @@ -352,6 +389,41 @@ struct cper_ia_proc_ctx {
>>   	__u64	mm_reg_addr;
>>   };
>>   
>> +/* ARMv8 Processor Error Section */
>> +struct cper_sec_proc_armv8 {
>> +	__u32	validation_bits;
>> +	__u16	err_info_num; /* Number of Processor Error Info */
>> +	__u16	context_info_num; /* Number of Processor Context Info Records*/
>> +	__u32	section_length;
>> +	__u8	affinity_level;
>> +	__u8	reserved[3];	/* must be zero */
>> +	__u64	mpidr;
>> +	__u64	midr;
>> +	__u32	running_state; /* Bit 0 set - Processor running. PSCI = 0 */
>> +	__u32	psci_state;
>> +};
>> +
>> +/* ARMv8 Processor Error Information Structure */
>> +struct cper_armv8_err_info {
>> +	__u8	version;
>> +	__u8	length;
>> +	__u16	validation_bits;
>> +	__u8	type;
>> +	__u16	multiple_error;
>> +	__u8	flags;
>> +	__u64	error_info;
>> +	__u64	virt_fault_addr;
>> +	__u64	physical_fault_addr;
>> +};
>
>> +/* ARMv8 AARCH64 Processor Context Information Structure */
>> +struct cper_armv8_aarch64_ctx {
>> +	__u8	type_el_ns;
>> +	__u8	reserved[7];	/* must be zero */
>> +	__u8	gpr[288];
>> +	__u8	spr[68];
>> +};
> Is this:
> "Table 265. ARM Processor Error Context Information Header Structure"?

This structure should be removed, it doesn't get used in code now.

Thanks,
Tyler

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.

