From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 01/20] efi: Add support for a UEFI variable filesystem
Date: Fri, 04 Jan 2013 20:58:36 +0000
Message-ID: <1357333116.8203.50.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1351237923-10313-1-git-send-email-matt@console-pimps.org>
	 <1351237923-10313-2-git-send-email-matt@console-pimps.org>
	 <50D3F995.5000705@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50D3F995.5000705-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>, Chun-Yi Lee <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 2012-12-21 at 13:54 +0800, Lingzhu Xiang wrote:
> On 10/26/2012 03:51 PM, Matt Fleming wrote:
> > +static int efivarfs_unlink(struct inode *dir, struct dentry *dentry)
> > +{
> > +	struct efivar_entry *var = dentry->d_inode->i_private;
> > +	struct efivars *efivars = var->efivars;
> > +	efi_status_t status;
> > +
> > +	spin_lock(&efivars->lock);
> > +
> > +	status = efivars->ops->set_variable(var->var.VariableName,
> > +					&var->var.VendorGuid,
> > +					    0, 0, NULL);
> > +
> > +	if (status == EFI_SUCCESS || status == EFI_NOT_FOUND) {
> > +		list_del(&var->list);
> > +		spin_unlock(&efivars->lock);
> > +		efivar_unregister(var);
> > +		drop_nlink(dir);
> 
> This should be  drop_nlink(dentry->d_inode);

Yep, this looks right. Care to send a proper patch with a Signed-off-by?

-- 
Matt Fleming, Intel Open Source Technology Center
