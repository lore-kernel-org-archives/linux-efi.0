From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH] Add esrt support.
Date: Tue, 9 Dec 2014 16:38:47 -0500
Message-ID: <20141209213847.GB1159@fenchurch.internal.datastacks.com>
References: <1416943684-11246-1-git-send-email-pjones@redhat.com>
 <20141208185720.GA11013@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20141208185720.GA11013-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, Dec 08, 2014 at 07:57:20PM +0100, Borislav Petkov wrote:
> On Tue, Nov 25, 2014 at 02:28:04PM -0500, Peter Jones wrote:
> > Add sysfs files for EFI System Resource Table under
> > /sys/firmware/efi/esrt and for each EFI System Resource Entry under
> > entries/ as a subdir.
> 
> Ok, let me make sure I know what I'm looking at:
> 
> This is a table which is supposed to describe a bunch of firmware blobs
> somewhere, correct?

Yes.  I'll add a comment explaining that.

> I've found this doc here: http://download.microsoft.com/download/5/F/5/5F5D16CD-2530-4289-8019-94C6A20BED3C/windows-uefi-firmware-update-platform.docx

It started life there, and there's also UEFI ECR 1090, and as such it'll
be formally defined in UEFI 2.5, but I can't provide a URL for either of
those at this time.

Unfortunately, there are a couple of bizarre things about the table, but
basically it got created and used in a fair number of platforms before
it got standardized, and I think they didn't want to make a second rev
of the table so early.  I'm not really sure I know why it landed as it
did, but there are some things I wish were different in the format.
That's life.

> The next question is: why do we need it exposed in sysfs? So that we
> know what firmware blobs the UEFI carries with it?

The point is to allow userland utilities to see which firmware
updates are /applicable/, and arrange (through external means) to have
them applied.  In particular, the plan is to read this data in userland,
and also to parse data files supplied with firmware images in userland,
determine what firmwares can be applied, and set up a UEFI binary to do
the update during the next reboot.

I'll add a comment somewhere to this effect.

> 
> > ---
> >  drivers/firmware/efi/Makefile |   2 +-
> >  drivers/firmware/efi/efi.c    |  37 +++-
> >  drivers/firmware/efi/esrt.c   | 402 ++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/efi.h           |   6 +
> >  4 files changed, 445 insertions(+), 2 deletions(-)
> >  create mode 100644 drivers/firmware/efi/esrt.c
> 
> Please run it through checkpatch - some of the warnings actually make
> sense.

Oh, sorry about that.  Will do.

> 
[snip]
> >  
> >  subsys_initcall(efisubsys_init);
> >  
> > +u64 efi_mem_max_reasonable_size(u64 phys_addr)
> 
> How am I to understand the function name? Find a reasonable size or is
> the size reasonable?

It is attempting to find the firmware's idea of the memory region the
table is in, and use that to tell us the maximum address the table may
occupy.  That is, since there's not very good data in the table to
verify its correctness, I want to enforce an upper bound to what we're
trying /somehow/.  EFI's memory map seems like the way to go.

Maybe I should go with "efi_mem_get_map_size()"?  Except as written it
does the subtraction internally, so it's really just what's /left/ of a
map after the provided address.  Suggestions welcome.  In the meantime,
I'll add a comment explaining this.

> 
> > +{
> > +	struct efi_memory_map *map = efi.memmap;
> > +	void *p, *e;
> > +
> > +	if (!map)
> > +		return 0;
> > +	if (WARN_ON(!map->phys_map))
> > +		return 0;
> > +	if (WARN_ON(map->nr_map == 0) || WARN_ON(map->desc_size == 0))
> 
> If this is going to be called pretty often maybe use WARN_ON_ONCE().
> Also, you probably want to return a negative value here so that caller
> can stop further processing. I mean, it does so now too but a negative
> value makes it more explicit.

Yeah, the negative number is a good point.  Right now I think, if I make
it stop iterating when that happens, then the WARN_ON won't be triggered
more than once per piece of code using it.  Right now that's once piece
of code.  I think even if it becomes more, that's probably the right thing,
because it indicates the calling code has done something wrong with the
data in the first place.

> > +		return 0;
> > +
> > +	e = map->phys_map + map->nr_map * map->desc_size;
> > +	for (p = map->phys_map; p < e; p += map->desc_size) {
> > +		/* If a driver calls this after efi_free_boot_services,
> > +		 * ->map will be NULL.  So just always get our own virtual
> > +		 * map on the CPU. */
> 
> Kernel comment style:
> 
> 	/*
> 	 * Blabla.
> 	 * Second sentence blabla.
> 	 */

Okay, I'll fix that.

> 
> > +		efi_memory_desc_t *md = phys_to_virt((phys_addr_t)p);
> 
> Maybe be more defensive here:
> 
> 		if (!md)
> 			continue;
> 
> Can this even happen, btw?

I don't think so?  I can't find an abundance of other code error
checking phys_to_virt().  AIUI it does nothing but temporarily
populate a TLB entry, and there's code /all over/ the kernel that
doesn't test its output, so I think it's reasonably safe.

> 
> > +		u64 size = md->num_pages << EFI_PAGE_SHIFT;
> > +		u64 end = md->phys_addr + size;
> > +		if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
> > +		    md->type != EFI_BOOT_SERVICES_CODE &&
> > +		    md->type != EFI_BOOT_SERVICES_DATA)
> > +			continue;
> 
> This test appears pretty often - maybe we need an inline function for
> it. It is unrelated to your patch, of course, I'm just mentioning it
> while we're here :-)

A worthwhile point, yeah.

> 
[trim]
> > +++ b/drivers/firmware/efi/esrt.c
> > @@ -0,0 +1,402 @@
> > +/*
> > + * esrt-sysfs.c
> 
> Either this should be esrt.c or the file should be called esrt-sysfs.c.

Yep, sorry for that.  Will fix.

> I say we create drivers/firmware/efi/sysfs/ and put all the
> sysfs-related stuff in there.

Sounds reasonable enough to me, but I think it should be a separate
patch from one that adds specific functionality.

> 
[lots of trimming I've done here]
> > +/* entry attribute */
> > +struct esre_sysfs_attribute {
> 
> I'd say no need for the "sysfs" in the name as the whole file is dealing
> implicitly with sysfs machinery.
> 
> Ditto for other names in here.

Okay.

> > +	struct attribute attr;
> > +	ssize_t (*show)(struct esre_sysfs_entry *entry, char *buf);
> > +};
> > +
> > +static struct esre_sysfs_entry *to_entry(struct kobject *kobj)
> > +{
> > +	return container_of(kobj, struct esre_sysfs_entry, kobj);
> > +}
> > +
> > +static struct esre_sysfs_attribute *to_attr(struct attribute *attr)
> > +{
> > +	return container_of(attr, struct esre_sysfs_attribute, attr);
> > +}
> > +
> > +static ssize_t esre_sysfs_attr_show(struct kobject *kobj,
> 
> Right, "esre_attr_show" should be perfectly fine IMO.
> 
> > +				    struct attribute *_attr, char *buf)
> > +{
> > +	struct esre_sysfs_entry *entry = to_entry(kobj);
> > +	struct esre_sysfs_attribute *attr = to_attr(_attr);
> > +
> > +	/* Don't tell normal users what firmware versions we've got... */
> > +	if (!capable(CAP_SYS_ADMIN))
> > +		return -EACCES;
> > +
> > +	return attr->show(entry, buf);
> > +}
> > +
> > +static const struct sysfs_ops esre_sysfs_attr_ops = {
> > +	.show = esre_sysfs_attr_show,
> > +};
> > +
> > +/* Generic ESRT Entry ("ESRE") support. */
> > +static ssize_t esre_sysfs_fw_class(struct esre_sysfs_entry *entry, char *buf)
> > +{
> > +	char *str = buf;
> > +	efi_guid_unparse(&entry->esre.fw_class, str);
> 
> Can someone enlighten me please why is this thing called "unparse"? It
> looks like a
> 
> 	efi_guit_to_str()
> 
> to me...

I couldn't agree more.

> 
> > +	str += strlen(str);
> > +	str += sprintf(str, "\n");
> > +
> > +	return str - buf;
> > +}
> > +
> > +static ssize_t esre_sysfs_fw_type(struct esre_sysfs_entry *entry, char *buf)
> > +{
> > +	return sprintf(buf, "%u\n", entry->esre.fw_type);
> > +}
> > +
> > +static ssize_t esre_sysfs_fw_version(struct esre_sysfs_entry *entry, char *buf)
> > +{
> > +	return sprintf(buf, "%u\n", entry->esre.fw_version);
> > +}
> > +
> > +static ssize_t esre_sysfs_lowest_supported_fw_version(struct esre_sysfs_entry *entry, char *buf)
> > +{
> > +	return sprintf(buf, "%u\n", entry->esre.lowest_supported_fw_version);
> > +}
> > +
> > +static ssize_t esre_sysfs_capsule_flags(struct esre_sysfs_entry *entry, char *buf)
> > +{
> > +	return sprintf(buf, "0x%x\n", entry->esre.capsule_flags);
> > +}
> > +
> > +static ssize_t esre_sysfs_last_attempt_version(struct esre_sysfs_entry *entry, char *buf)
> > +{
> > +	return sprintf(buf, "%u\n", entry->esre.last_attempt_version);
> > +}
> > +
> > +static ssize_t esre_sysfs_last_attempt_status(struct esre_sysfs_entry *entry, char *buf)
> > +{
> > +	return sprintf(buf, "%u\n", entry->esre.last_attempt_status);
> > +}
> 
> You could define those with a macro too - at least the common printing
> %u ones, like you've done with that ESRT_FIELD() macro below.

Honestly I'm not sure why there's not a higher level macro to do this -
other people have to dump %u and %x data into sysfs, don't they?  Is
there some radically different way I should be doing this altogether,
maybe?

Anyway, I've made all this macros in my next revision.

> 
> > +
> > +#define ESRE_SYSFS_ATTR(_name) \
> > +struct esre_sysfs_attribute esre_sysfs_attr_##_name = { \
> > +        .attr = {.name = __stringify(_name), .mode = 0400}, \
> 
> Ok, so those all are RO, so the purpose of this thing is purely
> informational so root can be able to tell what firmware is there in the
> UEFI.

Yes.

> 
> 
> > +	        .show = esre_sysfs_##_name, \
> > +}
> > +
> > +static ESRE_SYSFS_ATTR(fw_class);
> > +static ESRE_SYSFS_ATTR(fw_type);
> > +static ESRE_SYSFS_ATTR(fw_version);
> > +static ESRE_SYSFS_ATTR(lowest_supported_fw_version);
> > +static ESRE_SYSFS_ATTR(capsule_flags);
> > +static ESRE_SYSFS_ATTR(last_attempt_version);
> > +static ESRE_SYSFS_ATTR(last_attempt_status);
> > +
> > +static struct attribute *esre_sysfs_attrs[] = {
> > +	&esre_sysfs_attr_fw_class.attr,
> > +	&esre_sysfs_attr_fw_type.attr,
> > +	&esre_sysfs_attr_fw_version.attr,
> > +	&esre_sysfs_attr_lowest_supported_fw_version.attr,
> > +	&esre_sysfs_attr_capsule_flags.attr,
> > +	&esre_sysfs_attr_last_attempt_version.attr,
> > +	&esre_sysfs_attr_last_attempt_status.attr,
> > +	NULL
> > +};
> > +
> > +static void esre_sysfs_release(struct kobject *kobj)
> > +{
> > +	struct esre_sysfs_entry *entry = to_entry(kobj);
> > +
> > +	list_del(&entry->list);
> > +	kfree(entry);
> > +}
> > +
> > +static struct kobj_type esre_sysfs_ktype = {
> > +	.release = esre_sysfs_release,
> > +	.sysfs_ops = &esre_sysfs_attr_ops,
> > +	.default_attrs = esre_sysfs_attrs,
> > +};
> > +
> > +static struct kobject *esrt_kobj;
> > +static struct kset *esrt_kset;
> > +
> > +static int esre_sysfs_create_sysfs_entry(efi_system_resource_entry_t *esre)
> 
> One "sysfs" too many.

Okay.

> 
> > +{
> > +	int rc;
> > +	struct esre_sysfs_entry *entry;
> > +	char *name;
> > +	int name_size;
> > +
> > +	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
> > +	if (!entry)
> > +		return -ENOMEM;
> > +
> > +	name_size = EFI_VARIABLE_GUID_LEN + 1;
> 
> AFAICT this is 37 bytes. It would be probably simple to allocate it on
> the stack of register_entries and hand it down to this function for
> using by zeroing it out each time. This way you can save yourself the
> second kzalloc here.

I get why you're saying it's small and thus I should put it on the
stack, but is there any good reason not to use the local stack here?
I'm thinking that's better, and I'll do it in the upcoming patch.  If
you do have a good reason, I'm happy to product another revision.

> 
> > +	name = kzalloc(name_size, GFP_KERNEL);
> > +	if (!name) {
> > +		kfree(entry);
> 
> You can solve that with goto and labels. The kernel is full of
> examples...

Yeah, I know how that works; having only 2 things to free, it didn't
seem like it made much difference.  Now that I'm down to one, that's
even more the case. :)

> 
> > +		return -ENOMEM;
> > +	}
> > +	efi_guid_unparse(&esre->fw_class, name);
> > +
> > +	memcpy(&entry->esre, esre, sizeof(*esre));
> > +	entry->kobj.kset = esrt_kset;
> > +	rc = kobject_init_and_add(&entry->kobj, &esre_sysfs_ktype, NULL,
> > +				  "%s", name);
> > +	if (rc) {
> > +		kfree(name);
> > +		kfree(entry);
> 
> ... this too.
> 
> > +		return rc;
> > +	}
> > +	kfree(name);
> > +
> > +	list_add_tail(&entry->list, &entry_list);
> > +	return 0;
> > +}
> > +
> > +/* support for displaying ESRT fields at the top level */
> > +#define ESRT_FIELD(name) ((esrt)->name)
> > +
> > +#define ESRT_ATTR_SHOW(name, size, fmt) \
> > +static ssize_t esrt_attr_##name##_show(struct kobject *kobj, \
> > +				  struct kobj_attribute *attr, char *buf) \
> > +{ \
> > +	return sprintf(buf, fmt, le##size##_to_cpu(ESRT_FIELD(name))); \
> > +} \
> > +\
> > +static struct kobj_attribute esrt_attr_##name = __ATTR(name, 0400, \
> > +	esrt_attr_##name##_show, NULL); \
> > +
> > +ESRT_ATTR_SHOW(fw_resource_count, 32, "%u\n");
> > +ESRT_ATTR_SHOW(fw_resource_count_max, 32, "%u\n");
> > +ESRT_ATTR_SHOW(fw_resource_version, 64, "%llu\n");
> > +
> > +static struct attribute *esrt_attrs[] = {
> > +	&esrt_attr_fw_resource_count.attr,
> > +	&esrt_attr_fw_resource_count_max.attr,
> > +	&esrt_attr_fw_resource_version.attr,
> > +	NULL,
> > +};
> > +
> > +static umode_t esrt_attr_is_visible(struct kobject *kobj,
> > +	struct attribute *attr, int n)
> 
> Arg alignment should be under the opening brace, i.e.:
> 
> static umode_t esrt_attr_is_visible(struct kobject *kobj,
> 				    struct attribute *attr, int n)
> 
> so that it is more perrty :-P

Awesomely that failed to align properly in email, but I take your point
and I'll fix it up.

> 
> > +{
> > +	if (!efi_enabled(EFI_CONFIG_TABLES))
> > +		return 0;
> > +	if (efi.esrt == EFI_INVALID_TABLE_ADDR)
> > +		return 0;
> > +	return attr->mode;
> > +}
> > +
> > +static struct attribute_group esrt_attr_group = {
> > +	.attrs = esrt_attrs,
> > +	.is_visible = esrt_attr_is_visible,
> > +};
> > +
> > +/* ioremap the table, copy it to kmalloced pages, and unmap it */
> > +static int esrt_duplicate_pages(void)
> > +{
> > +	efi_system_resource_table_t *tmpesrt;
> > +	efi_system_resource_entry_t *entries;
> > +	size_t size, max;
> > +
> > +	if (!efi_enabled(EFI_CONFIG_TABLES))
> > +		return 0;
> > +	if (efi.esrt == EFI_INVALID_TABLE_ADDR)
> > +		return 0;
> 
> This double-test is repeated from above, maybe it should be an inline
> function. I see it used again below also...

Okay.

> 
> > +
> > +	max = efi_mem_max_reasonable_size(efi.esrt);
> > +	size = sizeof(*esrt);
> > +
> > +	if (max < size) {
> > +		pr_err("ESRT does not fit on single memory map entry.\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	tmpesrt = ioremap(efi.esrt, size);
> > +	if (!tmpesrt) {
> > +		pr_err("ioremap failed.\n");
> > +		return -ENOMEM;
> > +	}
> > +
> > +	size += tmpesrt->fw_resource_count * sizeof (*entries);
> > +	if (max < size) {
> > +		pr_err("ESRT does not fit on single memory map entry.\n");
> > +		return -EINVAL;
> > +	}
> 
> We probably should protect ourselves on the upper end too in case
> ->fw_resource_count is nuts...

_max isn't actually a meaningful value at all (to us), and its naming is
quite unfortunate.  I've reworked this a bit to try and handle this
suggestion and those below, though.

> 
> > +
> > +	iounmap(tmpesrt);
> > +	tmpesrt = ioremap(efi.esrt, size);
> > +	if (!tmpesrt) {
> > +		pr_err("ioremap failed.\n");
> > +		return -ENOMEM;
> > +	}
> > +
> > +	if (tmpesrt->fw_resource_count > tmpesrt->fw_resource_count_max) {
> > +		pr_err("ESRT has invalid fw_resource_count:"
> > +		       "fw_resource_count_max::%d:%d.\n",
> > +		       tmpesrt->fw_resource_count,
> > +		       tmpesrt->fw_resource_count_max);
> > +		iounmap(tmpesrt);
> > +		return -EINVAL;
> > +	}
> 
> Ditto.

Oh, I've made a serious error here; _max here isn't actually what it
seems like, and obviously I need a comment to explain that and also to
fix this code, because it's wrong and I tricked myself with the name
from the spec as well.

> 
> > +
> > +	/* attempt to test /some/ boundary... 128 should be pretty excessive */
> > +	if (tmpesrt->fw_resource_count > 128) {
> > +		pr_err("ESRT says fw_resource_count has very large value %d.\n",
> > +		       tmpesrt->fw_resource_count);
> > +		iounmap(tmpesrt);
> > +		return -EINVAL;
> > +	}
> 
> ... ah, here it is, ->fw_resource_count_max might be nuts too. You
> probably should pull those checks up, before you use the values. And
> test against sane defaults and not trust the FW. 128 looks like an
> arbitrary chosen value, isn't this spec-ed somewhere?
> 
> I'm not saying the spec knows what it is doing either but at least it is
> there and people can point fingers at it.

No, this is apparently something neither I nor anybody else who read the
spec thought about at the time.  I count it as a personal failing :/

> 
> > +
> > +	esrt = kmalloc(size, GFP_KERNEL);
> > +	if (!esrt) {
> > +		iounmap(tmpesrt);
> > +		pr_err("kmalloc failed.\n");
> > +		return -ENOMEM;
> > +	}
> > +
> > +	memcpy(esrt, tmpesrt, size);
> > +	iounmap(tmpesrt);
> > +	return 0;
> 
> Also, I'd suggest using goto with labels here too.

Okay.

> 
> > +}
> > +
> > +static int register_entries(void)
> > +{
> > +	efi_system_resource_entry_t *entries = esrt->entries;
> > +	int i, rc;
> > +
> > +	if (!efi_enabled(EFI_CONFIG_TABLES))
> > +		return 0;
> > +	if (efi.esrt == EFI_INVALID_TABLE_ADDR)
> > +		return 0;
> > +
> > +	for (i = 0; i < le32_to_cpu(esrt->fw_resource_count); i++) {
> 
> I wouldn't trust what I'm getting from the fw and sanity-check it first,
> before iterating over it.

We actually already checked this.  register_entries() is operating on
the generated output from esrt_duplicate_pages(), which would have
returned error in the cases we don't believe it's sane.  In that case,
an error has been returned before this function is ever called.

> 
> > +		rc = esre_sysfs_create_sysfs_entry(&entries[i]);
> > +		if (rc < 0) {
> > +			pr_err("EFI System Resource Entry creation "
> > +			       "failed with error %d.\n", rc);
> > +			return rc;
> 
> You need to properly unwind here and destroy the successfully created
> sysfs entries if you encounter an error at some later entry which isn't
> the first.

Do I?  I'm returning to esrt_sysfs_init() here, and if this function
fails /that/ function will call cleanup_entry_list(), which does a
kobject_put() on each entry.  AFAICS, that's going to call
esre_release(), and that's all the cleanup that's needed.

Have I missed something?

> 
> > +		}
> > +	}
> > +	return 0;
> > +}
> > +
> > +static void cleanup_entry_list(void)
> > +{
> > +	struct esre_sysfs_entry *entry, *next;
> > +
> > +	list_for_each_entry_safe(entry, next, &entry_list, list) {
> > +		kobject_put(&entry->kobj);
> > +	}
> > +}
> > +
> > +static int __init esrt_sysfs_init(void)
> > +{
> > +	int error = -ENOMEM;
> 
> Useless variable initialization.

Okay.

> 
> > +
> > +	esrt_kobj = kobject_create_and_add("esrt", efi_kobj);
> > +	if (!esrt_kobj) {
> > +		pr_err("esrt: Firmware table registration failed.\n");
> 
> "esrt" prefix is done with pr_fmt, grep the kernel sources for examples.

Okay.

> > +		return -ENOMEM;
> > +	}
> > +
> > +	error = esrt_duplicate_pages();
> > +	if (error)
> > +		goto err_remove_esrt;
> 
> Move that call up, before the kobject_create_and_add(). It'll simplify
> the error path too.

Yep.

> 
> > +
> > +	error = sysfs_create_group(esrt_kobj, &esrt_attr_group);
> > +	if (error) {
> > +		pr_err("esrt: Sysfs attribute export failed with error %d.\n",
> > +		       error);
> > +		goto err_free_esrt;
> > +	}
> > +
> > +	esrt_kset = kset_create_and_add("entries", NULL, esrt_kobj);
> > +	if (!esrt_kset) {
> > +		pr_err("esrt: kset creation failed.\n");
> > +		error = -ENOMEM;
> > +		goto err_remove_group;
> > +	}
> > +
> > +	error = register_entries();
> > +	if (error)
> > +		goto err_cleanup_list;
> > +
> > +	pr_debug("esrt-sysfs: loaded.\n");
> 
> Debugging left-over?

Isn't that the definition of pr_debug()?  In theory if there's a bug
someday due to some bizarre table value, I'd like to be able to boot
with debugging and see that the message doesn't get printed...

> 
> > +
> > +	return 0;
> > +err_cleanup_list:
> > +	cleanup_entry_list();
> > +	kset_unregister(esrt_kset);
> > +err_remove_group:
> > +	sysfs_remove_group(esrt_kobj, &esrt_attr_group);
> > +err_free_esrt:
> > +	kfree(esrt);
> > +	esrt = NULL;
> > +err_remove_esrt:
> > +	kobject_put(esrt_kobj);
> > +	return error;
> 
> Yep, this is what I mean with goto and labels.

Right - apparently you and I have different thresholds for how much
cleanup you're doing before it's worthwhile.  I'm willing to accept your
evaluation of that.

> 
> > +}
> > +
> > +static void __exit esrt_sysfs_exit(void)
> > +{
> > +	pr_debug("esrt-sysfs: unloading.\n");
> 
> More debugging leftovers.

Same question/point above applies, though.  Seems like if something is
going wrong out in the real world, these would be worthwhile.

[cut the rest out as it had no more comments]

Thanks for the feedback, I'll incorporate it and send out a new version
soon.
-- 
        Peter
