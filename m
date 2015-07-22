From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Don't print an error on unsupported BGRT version.
Date: Wed, 22 Jul 2015 18:13:58 -0400
Message-ID: <20150722221358.GA2103@redhat.com>
References: <20150722165357.GC1203@jtriplet-mobl1>
 <1437585207-32516-1-git-send-email-pjones@redhat.com>
 <20150722182648.GC26620@cloud>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150722182648.GC26620@cloud>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Jul 22, 2015 at 11:26:48AM -0700, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org wrote:
> On Wed, Jul 22, 2015 at 01:13:27PM -0400, Peter Jones wrote:
> > BGRT can legitimately be a different version from what we support, and
> > that's a problem with the driver not supporting something, not an error
> > that needs to be surfaced to the user.
> > 
> > Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> As mentioned in my previous mail, please consider adding support for
> version 0 instead, which would fix this issue in a better way.
> 
> If that's not possible, then sure, this patch is fine.  But ideally this
> warning should tend to lead to a patch to the bgrt driver adding support
> for the new version (or in this case the old version), rather than just
> silencing the warning.

Well, the inherent problem with version 0 is that it /isn't/
standardized - though on the machine in front of me (a retail Lenovo X1
Carbon), eyeballing it, it looks exactly the same.  I don't know how
we'd verify that none of the fields mean anything different.  My
suspicion is that some spec from before it was part of ACPI exists, or
maybe some earlier proposal to ACPI had version=0, but I have no access
to ACPI proposals from before they became part of UEFI.  The fact that
some retail machines seem to have version=0 makes me think it
/might/ be safe, but I can't really tell.  For all I know windows has
special-cased it in vendor supplied drivers that check the oem_id.

I've got something now that makes sense on one machine, and I need to
check out a few more machines, and then I'll send something along.

-- 
        Peter
