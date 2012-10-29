From: Mike Waychison <mikew@google.com>
Subject: Re: [PATCH v3 7/7] Add a format check for an existing variable name
 at erasing time
Date: Mon, 29 Oct 2012 13:24:26 -0700
Message-ID: <CAGTjWtAfaXgx_v46zf_fJ7KhBUTgciU7yedX6w2niER-JQBzTA@mail.gmail.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D41388F059@USINDEM103.corp.hds.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D41388F059@USINDEM103.corp.hds.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>, "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>, "dzickus@redhat.com" <dzickus@redhat.com>, "dle-develop@lists.sourceforge.net" <dle-develop@lists.sourceforge.net>, Satoru Moriya <satoru.moriya@hds.com>
List-Id: linux-efi@vger.kernel.org

On Fri, Oct 26, 2012 at 2:43 PM, Seiji Aguchi <seiji.aguchi@hds.com> wrote:
> [Issue]
>
> A format of variable name has been updated to type, id, count and ctime
> to support holding multiple logs.
>
> Format of current variable name
>   dump-type0-1-2-12345678
>
>   type:0
>   id:1
>   count:2
>   ctime:12345678
>
> On the other hand, if an old variable name before being updated
> remains, users can't erase it via /dev/pstore.
>
> Format of old variable name
>   dump-type0-1-12345678
>
>   type:0
>   id:1
>   ctime:12345678
>
> [Solution]
>
> This patch adds a format check for the old variable name in a erase callback to make it erasable.
>
> Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
> ---
>  drivers/firmware/efivars.c |   14 ++++++++++++--
>  1 files changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
> index dd228d5..b1cd028 100644
> --- a/drivers/firmware/efivars.c
> +++ b/drivers/firmware/efivars.c
> @@ -777,6 +777,8 @@ static int efi_pstore_erase(enum pstore_type_id type, u64 id, int count,
>         struct efivars *efivars = psi->data;
>         struct efivar_entry *entry, *found = NULL;
>         int i;
> +       unsigned int type_old, part_old;
> +       unsigned long time_old;
>
>         sprintf(name, "dump-type%u-%u-%d-%lu", type, (unsigned int)id, count,
>                 time.tv_sec);
> @@ -796,8 +798,16 @@ static int efi_pstore_erase(enum pstore_type_id type, u64 id, int count,
>                 if (efi_guidcmp(entry->var.VendorGuid, vendor))
>                         continue;
>                 if (utf16_strncmp(entry->var.VariableName, efi_name,
> -                                 utf16_strlen(efi_name)))
> -                       continue;
> +                                 utf16_strlen(efi_name))) {
> +                       /*
> +                        * Check if an old format,
> +                        * which doesn't support holding
> +                        * multiple logs, remains.
> +                        */
> +                       if (sscanf(name, "dump-type%u-%u-%lu",
> +                                  &type_old, &part_old, &time_old) != 3)

This doesn't look right.  This should probably mirror the sprintf() at
the top of the function using a new string, convert it to 16-bit
Unicodeand then compare it like we do for the 4-variable version above
(please ignore the fact that this driver incorrectly calls these
strings utf16 everywhere -- that needs to be fixed).

> +                               continue;
> +               }
>
>                 /* found */
>                 found = entry;
> -- 1.7.1
