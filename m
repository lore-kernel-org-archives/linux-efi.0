From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH v5 6/8] efi: load SSTDs from EFI variables
Date: Mon, 4 Jul 2016 13:00:36 +0100
Message-ID: <20160704120036.GJ8415@codeblueprint.co.uk>
References: <1467404352-27101-1-git-send-email-octavian.purdila@intel.com>
 <1467404352-27101-7-git-send-email-octavian.purdila@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-i2c-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1467404352-27101-7-git-send-email-octavian.purdila@intel.com>
Sender: linux-i2c-owner@vger.kernel.org
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Mark Brown <broonie@kernel.org>, Wolfram Sang <wsa@the-dreams.de>, Joel Becker <jlbec@evilplan.org>, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org, irina.tirdea@intel.com, leonard.crestez@intel.com
List-Id: linux-efi@vger.kernel.org

(Sorry, didn't get chance to reply before you sent this version)

On Fri, 01 Jul, at 11:19:10PM, Octavian Purdila wrote:
> +
> +static __init int efivar_ssdt_load(void)
> +{
> +	struct efivar_entry *entry;
> +	/* We need a temporary empty list to be able to set duplicates
> +	 * to true so that the efivar lock is dropped to allow us to
> +	 * call efivar_entry_get from the iterator function.
> +	 */
> +	LIST_HEAD(tmp);
> +	int ret;

I suspect you actually want to enable duplicate detection though,
because that bug (GetNextVariable() returning the same variable over
and over) does exist in the wild and it isn't that much more work to
enable the check.

Yes, the stack-local list looks like the right approach, because you
don't need access to these entries once this function returns.

Just be sure to free all those entries after efivar_init(), which
doesn't need to be done under efivar_entry_iter_{begin,end}() because
no one can concurrently access the list anyway.

Also...

	/*
	 * Multi-line comments should look like this, with the empty
	 * first line.
	 */

> +
> +	/* efivar_entry is too big to allocate it on stack */
> +	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
> +	if (!entry)
> +		return -ENOMEM;
> +	ret = efivar_init(efivar_ssdt_iter, entry, true, &tmp);
> +	kfree(entry);
> +	return ret;
> +}
> +#else
> +static inline int efivar_ssdt_load(void) { return 0; }
> +#endif

My suggestion is,

  - Push the 'entry' allocation into efivar_ssdt_iter()
  - Add 'entry' to the stack-local tmp list via efivar_entry_add()
  - Iterate 'tmp' and free entries before returning from efivar_ssdt_load()

Make sense?
