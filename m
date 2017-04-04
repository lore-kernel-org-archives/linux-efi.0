From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: kexec regression since 4.9 caused by efi
Date: Tue, 4 Apr 2017 14:37:19 +0100
Message-ID: <20170404133719.GE19827@codeblueprint.co.uk>
References: <20170308201616.GC8598@vader>
 <20170309063806.GB17257@dhcp-128-65.nay.redhat.com>
 <20170309095408.GA17883@vader>
 <20170313073748.GA6332@dhcp-128-65.nay.redhat.com>
 <20170316124132.GF6261@codeblueprint.co.uk>
 <20170317020951.GA3942@dhcp-128-65.nay.redhat.com>
 <20170317133232.GI6261@codeblueprint.co.uk>
 <20170320021412.GA3793@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170320021412.GA3793-0VdLhd/A9Pl+NNSt+8eSiB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Omar Sandoval <osandov-nWWhXC5lh1RBDgjK7y7TUQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 20 Mar, at 10:14:12AM, Dave Young wrote:
> 
> Matt, I'm fine if you prefer to capture the range checking errors.
> Would you like me to post it or just you send it out?

Can you please send out the patch with the minimal change to
efi_arch_mem_reserve() and we'll get it into urgent ASAP.
