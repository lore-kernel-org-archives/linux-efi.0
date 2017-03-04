From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: PROBLEM: Unexpected contents of load options (EFI Boot Stub)
Date: Sat, 4 Mar 2017 15:45:57 +0000
Message-ID: <CAKv+Gu9NqGWyw==dBKEdS9XwZcJhh9_Hg94G+sjbu48=aEbYTA@mail.gmail.com>
References: <773c29b9-37b4-e007-c336-c4beab7cde91@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <773c29b9-37b4-e007-c336-c4beab7cde91-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Fabian Tschiatschek <fabian.tschiatschek-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 4 March 2017 at 10:45, Fabian Tschiatschek
<fabian.tschiatschek-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Trying to load Linux 4.10.0 (x86_64) on a Dell XPS 15 9550 [1]
> using the firmware boot manager (BIOS revision 1.2.19; dated
> January 23, 2017 on Dell's website) results in the following
> kernel panic:
>
>   VFS: Unable to mount root fs on unknown-block(0,0)
>
> The kernel panic occurs even though a valid initrd kernel
> parameter is supplied through the OptionalData parameter [2]
> of the corresponding load option descriptor.
>
> Adding debug output to function make_boot_params in eboot.c to
> display a hex dump of the memory contents at the location pointed
> to by member load_options of efi_loaded_image_t indicates that
> load_options points to the beginning of the load option
> descriptor, i.e. to the Attributes parameter [3]. This seems to
> be unexpected behavior since later on the function tries to
> interpret the memory area as UTF-16 string. The code seems to
> assume that load_options points to the OptionalData parameter.
>
> In my case the Attributes parameter [2] has value 1 and thus the
> upper 16 bits of it are zero. This causes efi_convert_cmdline to
> stop converting after one (non-printing) character. Since the
> kernel command line obtained in this way misses the initrd
> kernel parameter the system fails to boot.
>
> If I adjust members load_options and load_options_size of
> efi_loaded_image_t by calculating the offset to parameter
> OptionalData as described under parameters FilePathListLength
> and OptionalData in [2] the system boots correctly.
>
> Is there anything I am missing? How should I proceed to fix this
> issue
>

The EFI_LOAD_OPTION struct that you refer to defines the format of
Boot#### and Driver#### UEFI variables. If the firmware is setting the
LoadOptions member of EFI_LOADED_IMAGE_PROTOCOL instances to point to
the top of such a structure rather than to its OptionalData member, it
is violating the spec.

EFI_LOAD_OPTION::OptionalData is described as

"""
OptionalData
The remaining bytes in the load option descriptor are a binary
data buffer that is passed to the loaded image. If the field is zero
bytes long, a NULL pointer is passed to the loaded image. The
number of bytes in OptionalData can be computed by
subtracting the starting offset of OptionalData from total size
in bytes of the EFI_LOAD_OPTION.
"""

So the binary data buffer is passed to the loaded image, which implies
that whatever comes before it is not.

I'm afraid your only option is to use an intermediate loader such as
GRUB which does not take any command line arguments.
