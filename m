From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Remove warning in efi_enter_virtual_mode
Date: Thu, 18 Apr 2013 09:38:04 -0700
Message-ID: <5170216C.9020300@zytor.com>
References: <1366127886-31460-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie> <516EAC4A.6040202@console-pimps.org> <516F1B90.9040508@nexus-software.ie> <516FD24A.3070502@console-pimps.org> <20130418163325.GA6884@leaf>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130418163325.GA6884@leaf>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Bryan O'Donoghue <bryan.odonoghue.lkml-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Darren Hart <darren.hart-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 04/18/2013 09:33 AM, Josh Triplett wrote:
> On Thu, Apr 18, 2013 at 12:00:26PM +0100, Matt Fleming wrote:
>>> No, no - we *don't* have a BGRT object at all.
>>>
>>> We have a completely clean memory map - but the BGRT code is causing the
>>> is_ram() failure.
>>  
>> You assume that mapping of the Boot Services regions is done purely for
>> the benefit of pulling out the bgrt image - it's not, see the above
>> commit log - and I assumed that you had an ACPI bgrt pointer in your
>> memory map, but you don't.
>>
>> Darren, Josh, have you ever seen an i386 machine with a bgrt pointer? If
>> not, and given that we've never seen an i386 firmware that requires the
>> above workaround from Matthew, combined with the fact that there are so
>> few i386 implementations out there, I'm inclined to apply the patch
>> below, because anything else is a lot more work. We can address this
>> properly if we ever start seeing i386 machines with bgrt pointers that
>> reference highmem.
> 
> The machine I developed the BGRT changes on kept the image below the 4G
> mark, inside one of the memory regions reclaimable via
> ExitBootServices().
> 

Well, highmem is >= ~896M.  Do you have a machine with BGRT over the
highmem mark?

	-hpa
