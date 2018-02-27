From: Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH v2 2/8] efi: Decode IA32/X64 Processor Error Section
Date: Tue, 27 Feb 2018 19:34:17 +0100
Message-ID: <20180227183417.GP26382@pd.tnic>
References: <20180226193904.20532-1-Yazen.Ghannam@amd.com>
 <20180226193904.20532-3-Yazen.Ghannam@amd.com>
 <20180227112234.GE26382@pd.tnic>
 <DM5PR12MB1916B6AEE434A345E78BE234F8C00@DM5PR12MB1916.namprd12.prod.outlook.com>
 <20180227170034.GJ26382@pd.tnic>
 <DM5PR12MB1916F8C7DF93C1C9402AE3ECF8C00@DM5PR12MB1916.namprd12.prod.outlook.com>
 <20180227174446.GN26382@pd.tnic>
 <DM5PR12MB1916C280DA5B51FE9666EE21F8C00@DM5PR12MB1916.namprd12.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <DM5PR12MB1916C280DA5B51FE9666EE21F8C00@DM5PR12MB1916.namprd12.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Ghannam, Yazen" <Yazen.Ghannam@amd.com>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>, "x86@kernel.org" <x86@kernel.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Feb 27, 2018 at 06:06:21PM +0000, Ghannam, Yazen wrote:
> It's not just about arches but record types. A single platform can report
> using arch-specific records, memory records, PCIe records, etc.
> 
> So all the other record types only show fields with a valid bit set and this
> has always been the case. There may be users or tools who expect that
> same behavior.

You know we have this thing called tracepoints for that, don't you?

You define one tracepoint which regurgitates an error record and then
all arches which have the same table, share them.

> Please see the other patches where these are decoded further. As I
> mentioned the cover letter, the decoding is applied incrementally rather
> than having one large patch.

Here's what needs to go:

All the validation bits crap:

	printk("%sValidation Bits: 0x%04x\n", pfx, validation_bits);

Instead, you simply dump all entries unconditionally and say whether
they're valid or not. This way you have the same format for each error
record - much easier to work with.

	printk("%sCPUID Info:\n", pfx);
        print_hex_dump(pfx, "", DUMP_PREFIX_OFFSET, 16, 4, proc->cpuid,
                       sizeof(proc->cpuid), 0);

Frankly, I have no clue why we should even dump CPUID for *every* error.
It is completely sufficient to dump family/model/stepping like we do in
mce_amd.c. Besides, when debugging, you collect much more info from the
system - CPUID only is not enough.

	printk("%sError Structure Type: %pUl\n", newpfx,
               &err_info->err_type);

Unreadable GUIDs.

What are those even:

                if (err_info->validation_bits & INFO_VALID_TARGET_ID) {
                        printk("%sTarget Identifier: 0x%016llx\n",
                               newpfx, err_info->target_id);
                }

                if (err_info->validation_bits & INFO_VALID_REQUESTOR_ID) {
                        printk("%sRequestor Identifier: 0x%016llx\n",
                               newpfx, err_info->requestor_id);
                }

                if (err_info->validation_bits & INFO_VALID_RESPONDER_ID) {
                        printk("%sResponder Identifier: 0x%016llx\n",
                               newpfx, err_info->responder_id);
                }

some 8-byte ids? Who knows... Either remove them or make them
human-readable, *explaining* what the requestor is and the target is and
so on.

                printk("%sRegister Array Size: 0x%04x\n", newpfx,
                       ctx_info->reg_arr_size);

I have no clue what that is for.

                if (ctx_info->reg_ctx_type == CTX_TYPE_MSR) {
                        groupsize = 8; /* MSRs are 8 bytes wide. */
                        printk("%sMSR Address: 0x%08x\n", newpfx,
                               ctx_info->msr_addr);
                }

What do I need the MSR *addresses* for?

                if (ctx_info->reg_ctx_type == CTX_TYPE_MMREG) {
                        printk("%sMM Register Address: 0x%016llx\n", newpfx,
                               ctx_info->mm_reg_addr);
                }

memory mapped registers?!?!

> Also, like I said in another thread, we should always print the raw value
> followed by the decoding. That way the raw info is there in case a user
> wants to send the data to the vendor or other expert party.

By that logic we shouldn't be decoding at all - we should be dumping a
fat hex blob.

Again, there's this thing called tracepoints which have exactly that,
you know. You can dump human readable info to dmesg and dump a whole raw
record into the tracepoint.

When the error is critical and we're about to die, the tracepoint
contents goes to dmesg too.

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
