From: Michael Brown <mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
Subject: Re: [PATCH v3] efi: Request desired alignment via the PE/COFF headers
Date: Tue, 16 Jun 2015 17:19:29 +0100
Message-ID: <55804C91.4030000@fensystems.co.uk>
References: <1405007963-520-1-git-send-email-mbrown@fensystems.co.uk> <loom.20150615T232724-11@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <loom.20150615T232724-11-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linn Crosetto <linn-VXdhtT5mjnY@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 15/06/15 22:43, Linn Crosetto wrote:
> Michael Brown <mbrown@...> writes:
>> The kernel will align itself to the nearest boundary specified by the
>> kernel_alignment field in the bzImage header.  If the kernel is loaded
>> to an address which is not sufficiently aligned, it will therefore use
>> memory beyond that indicated solely by the init_size field.
>>
>> The PE/COFF headers now include a .bss section to describe the
>> requirements of the init_size field, but do not currently expose the
>> alignment requirement.  Consequently, a kernel loaded via the PE entry
>> point may still end up overwriting unexpected areas of memory.
>>
>> Fix by exposing the desired alignment via the SectionAlignment field
>> in the PE/COFF headers.  Despite its name, this field provides an
>> overall alignment requirement for the loaded file.  (Naturally, the
>> FileAlignment field describes the alignment for individual sections.)
>>
>> There is no way in the PE/COFF headers to express the concept of
>> min_alignment; we therefore do not expose the minimum (as opposed to
>> preferred) alignment.
>
> <snip>
>
> There may be a problem with this change. The specification says that the
> SizeOfImage field must be a multiple of SectionAlignment. That was the case
> when SectionAlignment was 0x20, but now that it is so large it would
> require quite an increase in the last section to comply. A kernel I am
> looking at now has:
>
> Alignment of sections:	0x1000000
> Size of image:	0x105a000

Any suggested solution?

Michael
