From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] partitions/efi: Fix integer overflow in GPT size calculation
Date: Tue, 17 Jan 2017 16:00:39 +0000
Message-ID: <CAKv+Gu_-KHpFTSoTmAf8kWxVo2BzL9y3ZTfjWvwgT-m6-RsHjQ@mail.gmail.com>
References: <1484519516-18295-1-git-send-email-alden.tondettar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1484519516-18295-1-git-send-email-alden.tondettar@gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Alden Tondettar <alden.tondettar@gmail.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>, Jens Axboe <axboe@kernel.dk>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, linux-block@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 15 January 2017 at 22:31, Alden Tondettar <alden.tondettar@gmail.com> wrote:
> If a GUID Partition Table claims to have more than 2**25 entries, the
> calculation of the partition table size in alloc_read_gpt_entries() will
> overflow a 32-bit integer and not enough space will be allocated for the
> table.
>
> Nothing seems to get written out of bounds, but later efi_partition() will
> read up to 32768 bytes from a 128 byte buffer, possibly OOPSing or exposing
> information to /proc/partitions and uevents.
>
> The problem exists on both 64-bit and 32-bit platforms.
>
> Fix the overflow and also print a meaningful debug message if the table
> size is too large.
>
> Signed-off-by: Alden Tondettar <alden.tondettar@gmail.com>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  block/partitions/efi.c | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
>
> diff --git a/block/partitions/efi.c b/block/partitions/efi.c
> index bcd86e5..39f70d9 100644
> --- a/block/partitions/efi.c
> +++ b/block/partitions/efi.c
> @@ -293,7 +293,7 @@ static gpt_entry *alloc_read_gpt_entries(struct parsed_partitions *state,
>         if (!gpt)
>                 return NULL;
>
> -       count = le32_to_cpu(gpt->num_partition_entries) *
> +       count = (size_t)le32_to_cpu(gpt->num_partition_entries) *
>                  le32_to_cpu(gpt->sizeof_partition_entry);
>         if (!count)
>                 return NULL;
> @@ -352,7 +352,7 @@ static int is_gpt_valid(struct parsed_partitions *state, u64 lba,
>                         gpt_header **gpt, gpt_entry **ptes)
>  {
>         u32 crc, origcrc;
> -       u64 lastlba;
> +       u64 lastlba, pt_size;
>
>         if (!ptes)
>                 return 0;
> @@ -434,13 +434,20 @@ static int is_gpt_valid(struct parsed_partitions *state, u64 lba,
>                 goto fail;
>         }
>
> +       /* Sanity check partition table size */
> +       pt_size = (u64)le32_to_cpu((*gpt)->num_partition_entries) *
> +               le32_to_cpu((*gpt)->sizeof_partition_entry);
> +       if (pt_size > KMALLOC_MAX_SIZE) {
> +               pr_debug("GUID Partition Table is too large: %llu > %lu bytes\n",
> +                        (unsigned long long)pt_size, KMALLOC_MAX_SIZE);
> +               goto fail;
> +       }
> +
>         if (!(*ptes = alloc_read_gpt_entries(state, *gpt)))
>                 goto fail;
>
>         /* Check the GUID Partition Entry Array CRC */
> -       crc = efi_crc32((const unsigned char *) (*ptes),
> -                       le32_to_cpu((*gpt)->num_partition_entries) *
> -                       le32_to_cpu((*gpt)->sizeof_partition_entry));
> +       crc = efi_crc32((const unsigned char *) (*ptes), pt_size);
>
>         if (crc != le32_to_cpu((*gpt)->partition_entry_array_crc32)) {
>                 pr_debug("GUID Partition Entry Array CRC check failed.\n");
> --
> 2.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
