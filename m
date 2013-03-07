From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] efivarfs: fix abnormal GUID in variable name by using
 strcpy to replace null with dash
Date: Thu, 07 Mar 2013 13:57:43 +0000
Message-ID: <1362664663.15011.194.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1362108018-13117-1-git-send-email-jlee@suse.com>
	 <1362151068.2842.440.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1362155493.2842.446.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1362181299.23932.168.camel@linux-s257.site>
	 <1362555258.23932.573.camel@linux-s257.site>
	 <1362568750.15011.24.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1362652440.28562.26.camel@linux-s257.site>
	 <1362656348.15011.166.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1362656348.15011.166.camel-ZqTwcBeJ+wsBof6jY8KHXm7IUlhRatedral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Schroeder <mls-IBi9RG/b67k@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Frederic Crozat <fcrozat-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 2013-03-07 at 11:39 +0000, Matt Fleming wrote:
> On Thu, 2013-03-07 at 18:34 +0800, joeyli wrote:
> > The VariableNameSize is not reliable when EFI_SUCCESS is returned
> > because UEFI 2.3.1 spec only mention VariableNameSize should updated
> > when EFI_BUFFER_TOO_SMALL is returned. And, the 1024 bytes of buffer is
> > from old UEFI spec. There doesn't have any size condition of variable
> > data or variable name in 2.3.1 spec.
> 
> The spec may only mention what happens in the EFI_BUFFER_TOO_SMALL case,
> but for EFI_SUCCESS, any behaviour other than leaving VariableNameSize
> alone or updating it with the required size of the buffer is just
> completely insane.
> 
> > I modified the patch to grab VariableNameSize when EFI_BUFFER_TOO_SMALL,
> > the behavior like what we do in efivarfs_file_read().
> 
> Thanks, this does seem like the most robust solution.

Also, you're probably going to need to update
efivar_update_sysfs_entries() too.

-- 
Matt Fleming, Intel Open Source Technology Center
