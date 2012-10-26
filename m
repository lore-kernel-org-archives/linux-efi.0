From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 03/20] efi: add efivars kobject to efi sysfs folder
Date: Fri, 26 Oct 2012 12:13:44 +0100
Message-ID: <1351250024.5303.68.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1351237923-10313-1-git-send-email-matt@console-pimps.org>
	 <1351237923-10313-4-git-send-email-matt@console-pimps.org>
	 <20121026111347.209c11c5@pyramind.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121026111347.209c11c5-38n7/U1jhRXW96NNrWNlrekiAK3p4hvP@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 2012-10-26 at 11:13 +0100, Alan Cox wrote:
> On Fri, 26 Oct 2012 08:51:46 +0100
> Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
> 
> > From: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > 
> > UEFI variable filesystem need a new mount point, so this patch add
> > efivars kobject to efi_kobj for create a /sys/firmware/efi/efivars
> > folder.
> > 
> > Cc: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Cc: H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
> > Signed-off-by: Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> > Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > ---
> >  drivers/firmware/efivars.c | 11 +++++++++++
> >  include/linux/efi.h        |  1 +
> >  2 files changed, 12 insertions(+)
> > 
> > diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
> > index 6d43bbd..4b12a8fd 100644
> > --- a/drivers/firmware/efivars.c
> > +++ b/drivers/firmware/efivars.c
> > @@ -1527,6 +1527,7 @@ void unregister_efivars(struct efivars *efivars)
> >  		sysfs_remove_bin_file(&efivars->kset->kobj, efivars->del_var);
> >  	kfree(efivars->new_var);
> >  	kfree(efivars->del_var);
> > +	kobject_put(efivars->kobject);
> 
> This makes no sense - you already always unregister the kset in
> register_efivars ?

Crap. Yes, you're completely right. Thanks Alan.

Joey, this chunk of your patch is incorrect,

@@ -1558,6 +1559,13 @@ int register_efivars(struct efivars *efivars,
 		goto out;
 	}
 
+	efivars->kobject = kobject_create_and_add("efivars", parent_kobj);
+	if (!efivars->kobject) {
+		pr_err("efivars: Subsystem registration failed.\n");
+		error = -ENOMEM;
+		goto err_unreg_vars;
+	}
+
 	/*
 	 * Per EFI spec, the maximum storage allocated for both
 	 * the variable name and variable data is 1024 bytes.
@@ -1602,6 +1610,9 @@ int register_efivars(struct efivars *efivars,
 
 	register_filesystem(&efivarfs_type);
 
+err_unreg_vars:
+	kset_unregister(efivars->kset);
+
 out:
 	kfree(variable_name);
 

because err_unreg_vars is in the *success* path, not the error path. So
even if we successfully register efivarfs, we still call
kset_unregister().

Could you please fix this and resubmit?

-- 
Matt Fleming, Intel Open Source Technology Center
