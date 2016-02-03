From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/5] efi: Make efivarfs entries immutable by default. (v3)
Date: Wed, 3 Feb 2016 13:18:00 -0500
Message-ID: <20160203181759.GB19297@redhat.com>
References: <1454517834-13736-1-git-send-email-pjones@redhat.com>
 <1454517834-13736-5-git-send-email-pjones@redhat.com>
 <20160203180016.GQ26698@linux-rxt1.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160203180016.GQ26698-empE8CJ7fzk2xCFIczX1Fw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, Feb 04, 2016 at 02:00:16AM +0800, joeyli wrote:
> On Wed, Feb 03, 2016 at 11:43:54AM -0500, Peter Jones wrote:
> > "rm -rf" is bricking some peoples' laptops because of variables being
> > used to store non-reinitializable firmware driver data that's required
> > to POST the hardware.
> > 
> > These are 100% bugs, and they need to be fixed, but in the mean time it
> > shouldn't be easy to *accidentally* brick machines.
> > 
> > We have to have delete working, and picking which variables do and don't
> > work for deletion is quite intractable, so instead make everything
> > immutable by default (except for a whitelist), and make tools that
> > aren't quite so broad-spectrum unset the immutable flag.
> > 
> > v2: adds Timeout to our whitelist.
> > v3:
> >  - takes the extra Timeout out of the whitelist
> >  - fixes whitelist matching to actually work
> >  - inverts the flag on efivarfs_get_inode() and calls it is_removable
> >  - adds documentation and test cases
> > 
> > Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> Tested-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>

Is this to say on 4/5 you did s/new_var->var./new_var->/ and then tested
the whole set?

-- 
        Peter
