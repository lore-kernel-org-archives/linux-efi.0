From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 2/2] efi: Make efivarfs entries immutable by default.
Date: Sat, 20 Feb 2016 11:54:11 +0000
Message-ID: <20160220115411.GA2412@codeblueprint.co.uk>
References: <1455638983-30455-1-git-send-email-pjones@redhat.com>
 <1455638983-30455-3-git-send-email-pjones@redhat.com>
 <20160218145650.GJ2651@codeblueprint.co.uk>
 <20160218192539.GB1515@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160218192539.GB1515-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 18 Feb, at 02:25:39PM, Peter Jones wrote:
> 
> Yes - the original one (the bottom here) the return is "is the variable
> valid", and we're declaring that anything outside of our list does not
> /need/ to be validated, and is thus valid.  
> 
> In the new one (top), the function is "does the variable match this
> entry in the table", and we're saying any case that isn't ASCII does not
> match, except by globbing.  The calling function, efivar_validate(),
> then never runs a ->validate() method on the variable data, eventually
> exits the loop having matched nothing, and returns true.
 
Thanks for that explanation.

> Do you want me to resend with the crash guid one line fix as its own
> separate patch?

Don't worry, I'll take care of it.
