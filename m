From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [BUG]: DELL XPS 8500 become a brick after fill too many entries
 to nvram.
Date: Mon, 11 Nov 2013 11:07:01 +0000
Message-ID: <20131111110701.GE22636@console-pimps.org>
References: <87fvr3h3b9.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87fvr3h3b9.fsf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Madper Xie <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 11 Nov, at 02:15:22PM, Madper Xie wrote:
> Howdy all,
>   For now we ensure at least ~5kb free space. But my dell xps still
>   become a brick after I add too many entries to my nvram. So maybe 5kb
>   is not safe enough. and 5kb is just aginst Samsung's laptop.
>   So should we enlarge EFI_MIN_RESERVE?

Urgh.............

Thanks for the report. Could you provide some more details?

 - Is your machine definitely bricked?
 - Exactly which Dell machine is this?
 - What were you doing to cause your machine to not boot? Using
   efibootmgr?
 - Please send your .config
 - Have you reported this to any BIOS engineers to confirm the cause of
   the bricking?
 - Have you got a dmesg from the machine before it broke?

-- 
Matt Fleming, Intel Open Source Technology Center
