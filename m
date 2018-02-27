From: Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH v2 2/8] efi: Decode IA32/X64 Processor Error Section
Date: Tue, 27 Feb 2018 18:00:35 +0100
Message-ID: <20180227170034.GJ26382@pd.tnic>
References: <20180226193904.20532-1-Yazen.Ghannam@amd.com>
 <20180226193904.20532-3-Yazen.Ghannam@amd.com>
 <20180227112234.GE26382@pd.tnic>
 <DM5PR12MB1916B6AEE434A345E78BE234F8C00@DM5PR12MB1916.namprd12.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <DM5PR12MB1916B6AEE434A345E78BE234F8C00@DM5PR12MB1916.namprd12.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Ghannam, Yazen" <Yazen.Ghannam@amd.com>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>, "x86@kernel.org" <x86@kernel.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Feb 27, 2018 at 03:13:11PM +0000, Ghannam, Yazen wrote:
> I decided to print the Validation Bits as a sanity check for whomever is looking
> at this. Since we only print fields with a valid bit, it may be confusing for users
> who don't know why fields are missing.

I suggested what to do about that already: print the fields unconditionally.

> Also, I don't think we should be interpreting the spec for the user. We should
> print the fields as they and users can refer back to the spec for more information.

This is a very very bad idea.

You can just as well dump binary blobs and then add a user script which
deciphers that. Oh wait, we had that, it is called mcelog and it is a
huge pain trying to decode an error properly.

By that same logic, we could simply dump 64-bit MCA MSR values.

And everytime we get an error, we have to go dig out the spec. Hell no!
We had that, we know it is awful, we won't have it again.

You want to decode everything and fully in the kernel so that you can
have a ready error record which people can simply *read* from dmesg and
know what the error is.

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
