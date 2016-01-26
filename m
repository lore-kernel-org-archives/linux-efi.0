From: Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 16/17] FDT: Add a helper to get specified name subnode
Date: Tue, 26 Jan 2016 20:27:29 +0800
Message-ID: <56A76631.2070802@huawei.com>
References: <1453519184-11908-1-git-send-email-zhaoshenglong@huawei.com> <1453519184-11908-17-git-send-email-zhaoshenglong@huawei.com> <alpine.DEB.2.02.1601261156340.3619@kaball.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.02.1601261156340.3619-7Z66fg9igcxYtxbxJUhB2Dgeux46jI+i@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org



On 2016/1/26 20:11, Stefano Stabellini wrote:
> On Sat, 23 Jan 2016, Shannon Zhao wrote:
>> > From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> > 
>> > Sometimes it needs to check if there is a node in FDT by full path.
>> > Introduce this helper to get the specified name subnode if it exists.
>> > 
>> > Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> > ---
>> > CC: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>> > ---
>> >  drivers/of/fdt.c       | 35 +++++++++++++++++++++++++++++++++++
>> >  include/linux/of_fdt.h |  2 ++
>> >  2 files changed, 37 insertions(+)
>> > 
>> > diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
>> > index 655f79d..112ec16 100644
>> > --- a/drivers/of/fdt.c
>> > +++ b/drivers/of/fdt.c
>> > @@ -645,6 +645,41 @@ int __init of_scan_flat_dt(int (*it)(unsigned long node,
>> >  }
>> >  
>> >  /**
>> > + * of_get_flat_dt_subnode_by_name - get subnode of specified node by name
>> > + *
>> > + * @node: the parent node
>> > + * @uname: the name of subnode
>> > + * @return offset of the subnode, or -FDT_ERR_NOTFOUND if there is none
>> > + */
>> > +
>> > +int of_get_flat_dt_subnode_by_name(unsigned long node, const char *uname)
>> > +{
>> > +	const void *blob = initial_boot_params;
>> > +	int offset;
>> > +	const char *pathp;
>> > +
>> > +	/* Find first subnode if it exists */
>> > +	offset = fdt_first_subnode(blob, node);
>> > +	if (offset < 0)
>> > +		return -FDT_ERR_NOTFOUND;
>> > +	pathp = fdt_get_name(blob, offset, NULL);
>> > +	if (strncmp(pathp, uname, strlen(uname)) == 0)
>> > +		return offset;
> Wouldn't this check succeed even if uname is "uefi" and the node
> name is actually "uefiiiii"?  You might have to use strcmp.
> 
Ah, yes. Will fix this.

> 
>> > +	/* Find other subnodes */
>> > +	do {
>> > +		offset = fdt_next_subnode(blob, offset);
>> > +		if (offset < 0)
>> > +			return -FDT_ERR_NOTFOUND;
>> > +		pathp = fdt_get_name(blob, offset, NULL);
>> > +		if (strncmp(pathp, uname, strlen(uname)) == 0)
>> > +			return offset;
>> > +	} while (offset >= 0);
> Rather than writing the name check twice, I think it would be best to
> code this loop as:
> 
>     for (offset = fdt_first_subnode(blob, offset);
>          offset >= 0;
>          offset = fdt_next_subnode(blob, offset)) {
> 
>          /* do name check */
> 
> 
> 
Thanks for your suggestion. Will change this.

-- 
Shannon
