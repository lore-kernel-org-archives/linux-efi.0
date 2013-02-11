From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH 1/2] efivarfs: Validate filenames much more aggressively
Date: Mon, 11 Feb 2013 15:01:09 +0000
Message-ID: <20130211150109.GK4503@ZenIV.linux.org.uk>
References: <1360592935-26026-1-git-send-email-matt@console-pimps.org>
 <1360592935-26026-2-git-send-email-matt@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1360592935-26026-2-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Feb 11, 2013 at 02:28:54PM +0000, Matt Fleming wrote:
> + * Return 1 if 'str' is a valid efivarfs filename of the form,
> + *
> + *	VariableName-12345678-1234-1234-1234-1234567891bc
> + */
> +static int efivarfs_valid_name(const char *str, int len)
> +{
> +	const char *s;
> +	int i, j;
> +	int ranges[2][5] = {
> +		{ 0, 9, 14, 19, 24 },
> +		{ 8, 13, 18, 23, 36 }
> +	};
> +
> +	/*
> +	 * We need a GUID, plus at least one letter for the variable name,
> +	 * plus the '-' separator
> +	 */
> +	if (len < GUID_LEN + 2)
> +		return 0;
> +
> +	s = strchr(str, '-');
> +	if (!s)
> +		return 0;
> +
> +	s++;			/* Skip '-' */
> +
> +	/* Ensure we have enough characters for a GUID */
> +	if (len - (s - str) != GUID_LEN)
> +		return 0;
> +
> +	/*
> +	 * Validate that 's' is of the correct format, e.g.
> +	 *
> +	 *	12345678-1234-1234-1234-123456789abc
> +	 */
> +	for (i = 0; i < 5; i++) {
> +		for (j = ranges[0][i]; j < ranges[1][i]; j++) {
> +			if (hex_to_bin(s[j]) < 0)
> +				return 0;
> +		}
> +
> +		if (j < GUID_LEN && s[j] != '-')
> +			return 0;
> +	}
> +
> +	return 1;

Yecchhh...  How about
	static const char dashes[GUID_LEN] = {
		[8] = 1, [13] = 1, [18] = 1, [23] = 1
	};
	const char *s = str + len - GUID_LEN;
	int i;
	/*
	 * We need a GUID, plus at least one letter for the variable name,
	 * plus the '-' separator
	 */
	if (len < GUID_LEN + 2)
		return 0;

	/* GUID should be right after the first '-' */
	if (s - 1 != strchr(str, '-'))
		return 0;

	/*
	 * Validate that 's' is of the correct format, e.g.
	 *
	 *	12345678-1234-1234-1234-123456789abc
	 */
	for (i = 0; i < GUID_LEN; i++) {
		if (dashes[i]) {
			if (*s++ != '-')
				return 0;
		} else {
			if (!isxdigit(*s++))
				return 0;
		}
	}
	return 1;

instead?
