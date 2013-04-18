From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] Remove warning in efi_enter_virtual_mode
Date: Thu, 18 Apr 2013 20:55:20 +0100
Message-ID: <51704FA8.7060801@console-pimps.org>
References: <1366127886-31460-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie> <516EAC4A.6040202@console-pimps.org> <516F1B90.9040508@nexus-software.ie> <516FD24A.3070502@console-pimps.org> <20130418163325.GA6884@leaf> <5170216C.9020300@zytor.com> <20130418164457.GB6884@leaf>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130418164457.GB6884@leaf>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Bryan O'Donoghue <bryan.odonoghue.lkml-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Darren Hart <darren.hart-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 04/18/2013 05:44 PM, Josh Triplett wrote:
>>> The machine I developed the BGRT changes on kept the image below the 4G
>>> mark, inside one of the memory regions reclaimable via
>>> ExitBootServices().
>>
>> Well, highmem is >= ~896M.  Do you have a machine with BGRT over the
>> highmem mark?
> 
> I don't have the machine in question anymore, and I don't remember.

Sorry, I should have been more clear - having a BGRT image in highmem
has never worked for the reasons I outlined in my previous mail. What I
was really asking was: is it OK that we now explicitly don't support
that case? I'm working on the assumption that it's pointless writing
support for the BGRT in highmem because no such i386 machines exist. If
the BGRT code works for your i386 right now, the address isn't in highmem.

If there are machines out there that would require us to write support,
it's probably worth doing now instead of punting. But it sounds like
there aren't any.

-- 
Matt Fleming, Intel Open Source Technology Center
