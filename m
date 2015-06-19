From: Michael Brown <mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
Subject: Re: [PATCH v3] efi: Request desired alignment via the PE/COFF headers
Date: Fri, 19 Jun 2015 13:25:31 +0100
Message-ID: <55840A3B.3000400@fensystems.co.uk>
References: <1405007963-520-1-git-send-email-mbrown@fensystems.co.uk> <loom.20150615T232724-11@post.gmane.org> <55804C91.4030000@fensystems.co.uk> <20150616173725.GE13153@oranje.fc.hp.com> <20150618220241.GA2776@codeblueprint.co.uk> <558345EB.8010408@fensystems.co.uk> <20150619122147.GC2776@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150619122147.GC2776-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Linn Crosetto <linn-VXdhtT5mjnY@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 19/06/15 13:21, Matt Fleming wrote:
>> If the patch is reverted, then I think it will cause undefined
>> behaviour on some platforms (which happen to load the kernel to
>> non-preferred alignment, and where the memory immediately after the
>> loaded kernel happens to be in use for something).
>
> I thought that we had previously established that this wasn't true?
>
> <snip>
>
> To which I replied with,
>
>> Right, this shouldn't be a problem because we do in fact allocate space
>> using the EFI boottime services in efi_relocate_kernel(), taking the
>> alignment into account, and then perform the kernel image copy.
>>
>> I still think your change makes sense, I'm just inclined to delete the
>> paragraph referring to the corruption bug (which we've established
>> doesn't exist).
>
> Do we still have a bug?

Ah; that was the old e-mail thread I couldn't find!

You are right; this change can safely be reverted.  Sorry for the noise.

Michael
