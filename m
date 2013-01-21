From: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] selftests: Add tests for efivarfs
Date: Mon, 21 Jan 2013 18:40:30 +0800
Message-ID: <50FD1B1E.5000208@redhat.com>
References: <1358500776.780948.518900415126.1.gpush@pecola>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1358500776.780948.518900415126.1.gpush@pecola>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 01/18/2013 05:19 PM, Jeremy Kerr wrote:
> This change adds a few initial efivarfs tests to the
> tools/testing/selftests directory.
> 

Nice idea. I might add a few look test cases or try some fs testsuites
on efivarfs.

> +	# the open-unlink test relies on deleting the Lang variable at
> +	# present; we don't want to do this on an actual machine.

It seems open-unlink already goes to delete a custom variable.

> +	if ! grep -q 'model name.* QEMU' /proc/cpuinfo; then
> +		echo $msg efivarfs tests should only be run on a VM >&2
> +		exit 0
> +	fi

This won't allow me to test. I use qemu-kvm -cpu host, /proc/cpuinfo
doesn't have the string "QEMU".

How about grep -q OVMF /sys/firmware/acpi/tables/DSDT? Or add a prompt
if it can't be determined?

> +# test that we can remove a variable by issuing a write with only
> +# attributes specified
> +test_zero_size_delete()
> +{
> +	local attrs='\x07\x00\x00\x00'
> +	local file=$efivarfs_mount/test.3-$test_guid
> +
> +	printf "$attrs\x00" > $file
> +
> +	if [ ! -e $file ]; then
> +		echo "$file does not exist" >&2
> +		exit 1
> +	fi
> +

test_zero_size_delete can't reproduce the file lingering bug on unpatched
3.8-rc4.

A remount is required to reproduce the bug for newly created variable, here:

        umount $efivarfs_mount
        mount -t efivarfs - $efivarfs_mount

If a variable exists at boot time, then no remount is required. This is why
I choosed RTC-$GUID. With this remount, I can verify the bug is fixed by
efivarfs: Delete dentry from dcache in efivarfs_file_write().

> +	/* create a test variable */
> +	fd = open(path, O_WRONLY | O_CREAT);
> +	if (fd < 0) {
> +		perror("open(O_WRONLY)");
> +		return EXIT_FAILURE;
> +	}
> +
> +	rc = write(fd, buf, sizeof(buf));
> +	if (rc != sizeof(buf)) {
> +		perror("write");
> +		return EXIT_FAILURE;
> +	}
> +
> +	close(fd);
> +

Likewise, we might want to test this with remount after file creation.

> +	fd = open(path, O_RDONLY);
> +	if (fd < 0) {
> +		perror("open");
> +		return EXIT_FAILURE;
> +	}

--
Lingzhu Xiang
