From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 09/14] efi: passing kexec necessary efi data via
 setup_data
Date: Thu, 12 Dec 2013 14:25:06 +0800
Message-ID: <20131212062506.GH3751@dhcp-16-126.nay.redhat.com>
References: <1386582147-9802-1-git-send-email-dyoung@redhat.com>
 <1386582147-9802-10-git-send-email-dyoung@redhat.com>
 <20131211222057.GB8863@pd.tnic>
 <20131212030619.GG3751@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131212030619.GG3751-je1gSBvt1TcFLmT5oZ11vB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
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

> > > + */
> > > +static int __init map_regions_fixed(void)
> > > +{
> > > +	int i, s, ret = 0;
> > > +	u64 end, systab;
> > > +	unsigned long size;
> > > +	efi_memory_desc_t *md;
> > > +	struct efi_setup_data *data;
> > > +
> > > +	s = sizeof(*data) + nr_efi_runtime_map * sizeof(data->map[0]);
> > > +	data = early_memremap(efi_setup, s);
> > > +	if (!data) {
> > > +		ret = -ENOMEM;
> > > +		goto out;
> > > +	}
> > 
> > newline.
> 
> Will remove

misread the comment, there's no new line here. Looks like you want a
new blank line here, ok..

> 
> > 
> > > +	for (i = 0, md = data->map; i < nr_efi_runtime_map; i++, md++) {
> > > +		efi_map_region_fixed(md); /* FIXME: add error handling */
> > > +		size = md->num_pages << PAGE_SHIFT;
> > > +		end = md->phys_addr + size;
> > > +
> > > +		systab = (u64) (unsigned long) efi_phys.systab;
> > > +		if (md->phys_addr <= systab && systab < end) {
> > > +			systab += md->virt_addr - md->phys_addr;
> > > +			efi.systab = (efi_system_table_t *)(unsigned long)systab;
> > > +		}
> > > +		ret = save_runtime_map(md, i);
> > 
