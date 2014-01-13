From: Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 1/4] x86, ptdump: Add the functionality to dump an arbitrary
 pagetable
Date: Mon, 13 Jan 2014 06:48:10 -0800
Message-ID: <52D3FCAA.7070004@linux.intel.com>
References: <1389473370-1940-1-git-send-email-bp@alien8.de> <1389473370-1940-2-git-send-email-bp@alien8.de> <20140113053240.GA11237@dhcp-16-126.nay.redhat.com> <20140113101822.GA5388@pd.tnic> <20140113122320.GA1900@darkstar.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140113122320.GA1900@darkstar.nay.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Young <dyoung@redhat.com>, Borislav Petkov <bp@alien8.de>
Cc: Linux EFI <linux-efi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>, Matt Fleming <matt@console-pimps.org>, Matthew Garrett <mjg59@srcf.ucam.org>, "H. Peter Anvin" <hpa@zytor.com>, Toshi Kani <toshi.kani@hp.com>
List-Id: linux-efi@vger.kernel.org

On 1/13/2014 4:23 AM, Dave Young wrote:
>>
>>> How about do not limit to only if (pgd) case, instead do something
>>> like below: set dump_to_dmesg as a module parameter
>>
>> X86_PTDUMP is not a module.
>
> Hmm, I just see the module macros in the code, since it's a bool Kconfig
> I think the dump_pagetables.c need a cleanup,
> remove the #include <linux/module.h> and below lines:
> MODULE_LICENSE("GPL");
> MODULE_AUTHOR("Arjan van de Ven <arjan@linux.intel.com>");
> MODULE_DESCRIPTION("Kernel debugging helper that dumps pagetables");

personally I consider it good form to always have this kind of information in .c files,
regardless of the KConfig side of thing...
