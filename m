From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [RFC PATCH v3 14/20] iommu/amd: Disable AMD IOMMU if memory
 encryption is active
Date: Mon, 14 Nov 2016 10:48:52 -0600
Message-ID: <b4403b85-42dd-66b2-bde6-726c6ac5ae0e@amd.com>
References: <20161110003426.3280.2999.stgit@tlendack-t1.amdoffice.net>
 <20161110003731.3280.67205.stgit@tlendack-t1.amdoffice.net>
 <20161114163204.GA2078@8bytes.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161114163204.GA2078@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Joerg Roedel <joro@8bytes.org>
Cc: linux-arch@vger.kernel.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, iommu@lists.linux-foundation.org, Rik van Riel <riel@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>, Larry Woodman <lwoodman@redhat.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@>
List-Id: linux-efi@vger.kernel.org

On 11/14/2016 10:32 AM, Joerg Roedel wrote:
> On Wed, Nov 09, 2016 at 06:37:32PM -0600, Tom Lendacky wrote:
>> +	/* For now, disable the IOMMU if SME is active */
>> +	if (sme_me_mask)
>> +		return -ENODEV;
>> +
> 
> Please print a message here telling the user why the IOMMU got disabled.

Will do.

Thanks,
Tom

> 
> 
> Thanks,
> 
> 	Joerg
> 
