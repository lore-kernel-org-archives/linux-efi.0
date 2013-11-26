From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 05/12] efi: export more efi table variable to sysfs
Date: Tue, 26 Nov 2013 17:13:01 +0800
Message-ID: <20131126091301.GB10899@dhcp-16-126.nay.redhat.com>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
 <1385445477-9665-6-git-send-email-dyoung@redhat.com>
 <20131126085035.GC20917@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131126085035.GC20917-fF5Pk5pvG8Y@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, toshi.kani-VXdhtT5mjnY@public.gmane.org, matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 11/26/13 at 09:50am, Borislav Petkov wrote:
> On Tue, Nov 26, 2013 at 01:57:50PM +0800, Dave Young wrote:
> > diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> > index 2e2fbde..5d85956 100644
> > --- a/drivers/firmware/efi/efi.c
> > +++ b/drivers/firmware/efi/efi.c
> > @@ -32,6 +32,9 @@ struct efi __read_mostly efi = {
> >  	.hcdp       = EFI_INVALID_TABLE_ADDR,
> >  	.uga        = EFI_INVALID_TABLE_ADDR,
> >  	.uv_systab  = EFI_INVALID_TABLE_ADDR,
> > +	.fw_vendor  = EFI_INVALID_TABLE_ADDR,
> > +	.runtime    = EFI_INVALID_TABLE_ADDR,
> > +	.config_table  = EFI_INVALID_TABLE_ADDR,
> 
> See what I mean with alignment?

Yes, I see. As for this segment I would not like change the previous code
just because of this reason

> 
> Now this config_table thing sticks out and completely destroys the
> balance in the universe.
> 
> :-)
> 
> >  };
> >  EXPORT_SYMBOL(efi);
> >  
> > @@ -71,13 +74,54 @@ static ssize_t systab_show(struct kobject *kobj,
> >  static struct kobj_attribute efi_attr_systab =
> >  			__ATTR(systab, 0400, systab_show, NULL);
> >  
> > +static ssize_t fw_vendor_show(struct kobject *kobj,
> > +				struct kobj_attribute *attr, char *buf)
> > +{
> > +	return sprintf(buf, "0x%lx\n", efi.fw_vendor);
> > +}
> > +
> > +static ssize_t runtime_show(struct kobject *kobj,
> > +				struct kobj_attribute *attr, char *buf)
> > +{
> > +	return sprintf(buf, "0x%lx\n", efi.runtime);
> > +}
> > +
> > +static ssize_t config_table_show(struct kobject *kobj,
> > +				struct kobj_attribute *attr, char *buf)
> > +{
> > +	return sprintf(buf, "0x%lx\n", efi.config_table);
> > +}
> 
> Those are sooo similar, it's like the macro SHOW writes itself.

Ok, will add a macro for the above functions..

Thanks for review
Dave
