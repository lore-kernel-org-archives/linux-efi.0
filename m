From: Joseph Yasi <joe.yasi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: efivarfs: guid part of filenames are case-insensitive is broken
Date: Tue, 5 Mar 2013 15:25:50 -0500
Message-ID: <CADzA9o=BreTPL3iDrjNBoD_ztHa1v_Y-STdOROG3xCVaV1k_BA@mail.gmail.com>
References: <CADzA9okmNOS429FJNEAMj7gUMKD9bU8jzznCoJ_=tyySGDE++A@mail.gmail.com>
	<5135AEEB.9090408@redhat.com>
	<1362486844.15011.8.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1362486844.15011.8.camel-ZqTwcBeJ+wsBof6jY8KHXm7IUlhRatedral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The patch works for me.

-Joe Yasi

On Tue, Mar 5, 2013 at 7:34 AM, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> On Tue, 2013-03-05 at 16:38 +0800, Lingzhu Xiang wrote:
>> On 03/05/2013 05:46 AM, Joseph Yasi wrote:
>> > Hi,
>> >
>> > With linux 3.8.2 I can no longer mount efivars on my Lenovo Thinkpad T530:
>> >
>> > $ sudo mount -v /sys/firmware/efi/efivars
>> > mount: Cannot allocate memory
>>
>> Looking at 47f531e8ba3bc3901a0c493f4252826c41dea1a1
>> efivarfs: Validate filenames much more aggressively
>>
>> In efivarfs_valid_name:
>>
>> +     /* GUID should be right after the first '-' */
>> +     if (s - 1 != strchr(str, '-'))
>> +             return false;
>>
>> But pstore creates entries like dump-type0-1-$timestamp-$GUID.
>>
>> efivarfs_alloc_dentry fails because it thinks pstore entry names
>> are invalid.
>>
>> EFI pstore dump is now enabled by default (as in Fedora), saving
>> dump sooner or later, so users will likely be affected by this.
>>
>> Manually creating a test-test-$GUID also reproduces this.
>
> Guh, yes. Spot on Lingzhu.
>
> Lingzhu, could you test the following patch? You seem to be particularly
> good at weeding out bugs in this code.
>
> ---
>
> From 5fe334c9734863642ac16a9685f3912fd218956a Mon Sep 17 00:00:00 2001
> From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Date: Tue, 5 Mar 2013 07:40:16 +0000
> Subject: [PATCH] efivars: efivarfs_valid_name() should handle pstore syntax
>
> Stricter validation was introduced with commit da27a24383b2b
> ("efivarfs: guid part of filenames are case-insensitive") and commit
> 47f531e8ba3b ("efivarfs: Validate filenames much more aggressively"),
> which is necessary for the guid portion of efivarfs filenames, but we
> don't need to be so strict with the first part, the variable name. The
> UEFI specification doesn't impose any constraints on variable names
> other than they be a NULL-terminated string.
>
> The above commits caused a regression that resulted in users seeing
> the following message,
>
>   $ sudo mount -v /sys/firmware/efi/efivars mount: Cannot allocate memory
>
> whenever pstore EFI variables were present in the variable store,
> since their variable names failed to pass the following check,
>
>     /* GUID should be right after the first '-' */
>     if (s - 1 != strchr(str, '-'))
>
> as a typical pstore filename is of the form, dump-type0-10-1-<guid>.
> The fix is trivial since the guid portion of the filename is GUID_LEN
> bytes, we can use (len - GUID_LEN) to ensure the '-' character is
> where we expect it to be.
>
> (The bogus ENOMEM error value will be fixed in a separate patch.)
>
> Reported-by: Joseph Yasi <joe.yasi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Reported-by: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>
> Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/firmware/efivars.c                   |  4 +-
>  tools/testing/selftests/efivarfs/efivarfs.sh | 59 ++++++++++++++++++++++++++++
>  2 files changed, 61 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
> index 0d50497..1b9a6e1 100644
> --- a/drivers/firmware/efivars.c
> +++ b/drivers/firmware/efivars.c
> @@ -974,8 +974,8 @@ static bool efivarfs_valid_name(const char *str, int len)
>         if (len < GUID_LEN + 2)
>                 return false;
>
> -       /* GUID should be right after the first '-' */
> -       if (s - 1 != strchr(str, '-'))
> +       /* GUID must be preceded by a '-' */
> +       if (*(s - 1) != '-')
>                 return false;
>
>         /*
> diff --git a/tools/testing/selftests/efivarfs/efivarfs.sh b/tools/testing/selftests/efivarfs/efivarfs.sh
> index 880cdd5..77edcdc 100644
> --- a/tools/testing/selftests/efivarfs/efivarfs.sh
> +++ b/tools/testing/selftests/efivarfs/efivarfs.sh
> @@ -125,6 +125,63 @@ test_open_unlink()
>         ./open-unlink $file
>  }
>
> +# test that we can create a range of filenames
> +test_valid_filenames()
> +{
> +       local attrs='\x07\x00\x00\x00'
> +       local ret=0
> +
> +       local file_list="abc dump-type0-11-1-1362436005 1234 -"
> +       for f in $file_list; do
> +               local file=$efivarfs_mount/$f-$test_guid
> +
> +               printf "$attrs\x00" > $file
> +
> +               if [ ! -e $file ]; then
> +                       echo "$file could not be created" >&2
> +                       ret=1
> +               else
> +                       rm $file
> +               fi
> +       done
> +
> +       exit $ret
> +}
> +
> +test_invalid_filenames()
> +{
> +       local attrs='\x07\x00\x00\x00'
> +       local ret=0
> +
> +       local file_list="
> +               -1234-1234-1234-123456789abc
> +               foo
> +               foo-bar
> +               -foo-
> +               foo-barbazba-foob-foob-foob-foobarbazfoo
> +               foo-------------------------------------
> +               -12345678-1234-1234-1234-123456789abc
> +               a-12345678=1234-1234-1234-123456789abc
> +               a-12345678-1234=1234-1234-123456789abc
> +               a-12345678-1234-1234=1234-123456789abc
> +               a-12345678-1234-1234-1234=123456789abc
> +               1112345678-1234-1234-1234-123456789abc"
> +
> +       for f in $file_list; do
> +               local file=$efivarfs_mount/$f
> +
> +               printf "$attrs\x00" 2>/dev/null > $file
> +
> +               if [ -e $file ]; then
> +                       echo "Creating $file should have failed" >&2
> +                       rm $file
> +                       ret=1
> +               fi
> +       done
> +
> +       exit $ret
> +}
> +
>  check_prereqs
>
>  rc=0
> @@ -135,5 +192,7 @@ run_test test_create_read
>  run_test test_delete
>  run_test test_zero_size_delete
>  run_test test_open_unlink
> +run_test test_valid_filenames
> +run_test test_invalid_filenames
>
>  exit $rc
> --
> 1.7.11.7
>
>
>
