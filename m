From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] efi: take size of partition entry from GPT header
Date: Mon, 10 Sep 2018 21:31:02 +0200
Message-ID: <CAKv+Gu_Di8sb6g1Hm3zoih-031Y1yORwXxd+Te68-2PeUioTiQ@mail.gmail.com>
References: <20180910190355.GA2166@vnote>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180910190355.GA2166@vnote>
Sender: linux-kernel-owner@vger.kernel.org
To: Eugene Korenevsky <ekorenevsky@gmail.com>, Davidlohr Bueso <dave@stgolabs.net>, linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 10 September 2018 at 21:03, Eugene Korenevsky <ekorenevsky@gmail.com> wrote:
> Use gpt_header.sizeof_partition_entry instead of sizeof(gpt_entry)
> for GPT entry size.
> According to UEFI spec, GPT entry size is specified in GPT header.
>

I think this patch is probably correct, but could you please provide
more information:
- why do you need this patch
- which UEFI spec section/paragraph are you quoting


> Signed-off-by: Eugene Korenevsky <ekorenevsky@gmail.com>
> ---
>  block/partitions/efi.c | 26 ++++++++++++--------------
>  1 file changed, 12 insertions(+), 14 deletions(-)
>
> diff --git a/block/partitions/efi.c b/block/partitions/efi.c
> index 39f70d968754..29f7ec585e1d 100644
> --- a/block/partitions/efi.c
> +++ b/block/partitions/efi.c
> @@ -428,11 +428,6 @@ static int is_gpt_valid(struct parsed_partitions *state, u64 lba,
>                          (unsigned long long)le64_to_cpu((*gpt)->first_usable_lba));
>                 goto fail;
>         }
> -       /* Check that sizeof_partition_entry has the correct value */
> -       if (le32_to_cpu((*gpt)->sizeof_partition_entry) != sizeof(gpt_entry)) {
> -               pr_debug("GUID Partition Entry Size check failed.\n");
> -               goto fail;
> -       }
>

Shouldn't we assert that sizeof_partition_entry >= sizeof(gpt_entry) ?

>         /* Sanity check partition table size */
>         pt_size = (u64)le32_to_cpu((*gpt)->num_partition_entries) *
> @@ -692,7 +687,7 @@ static int find_valid_gpt(struct parsed_partitions *state, gpt_header **gpt,
>  int efi_partition(struct parsed_partitions *state)
>  {
>         gpt_header *gpt = NULL;
> -       gpt_entry *ptes = NULL;
> +       gpt_entry *ptes = NULL, *pte;
>         u32 i;
>         unsigned ssz = bdev_logical_block_size(state->bdev) / 512;
>
> @@ -704,13 +699,16 @@ int efi_partition(struct parsed_partitions *state)
>
>         pr_debug("GUID Partition Table is valid!  Yea!\n");
>
> -       for (i = 0; i < le32_to_cpu(gpt->num_partition_entries) && i < state->limit-1; i++) {
> +       pte = ptes;
> +       for (i = 0; i < le32_to_cpu(gpt->num_partition_entries) && i < state->limit-1;
> +                       i++,
> +                       pte = (gpt_entry *)((u8*)pte + gpt->sizeof_partition_entry)) {
>                 struct partition_meta_info *info;
>                 unsigned label_count = 0;
>                 unsigned label_max;
> -               u64 start = le64_to_cpu(ptes[i].starting_lba);
> -               u64 size = le64_to_cpu(ptes[i].ending_lba) -
> -                          le64_to_cpu(ptes[i].starting_lba) + 1ULL;
> +               u64 start = le64_to_cpu(pte->starting_lba);
> +               u64 size = le64_to_cpu(pte->ending_lba) -
> +                          le64_to_cpu(pte->starting_lba) + 1ULL;
>
>                 if (!is_pte_valid(&ptes[i], last_lba(state->bdev)))
>                         continue;
> @@ -718,18 +716,18 @@ int efi_partition(struct parsed_partitions *state)
>                 put_partition(state, i+1, start * ssz, size * ssz);
>
>                 /* If this is a RAID volume, tell md */
> -               if (!efi_guidcmp(ptes[i].partition_type_guid, PARTITION_LINUX_RAID_GUID))
> +               if (!efi_guidcmp(pte->partition_type_guid, PARTITION_LINUX_RAID_GUID))
>                         state->parts[i + 1].flags = ADDPART_FLAG_RAID;
>
>                 info = &state->parts[i + 1].info;
> -               efi_guid_to_str(&ptes[i].unique_partition_guid, info->uuid);
> +               efi_guid_to_str(&pte->unique_partition_guid, info->uuid);
>
>                 /* Naively convert UTF16-LE to 7 bits. */
>                 label_max = min(ARRAY_SIZE(info->volname) - 1,
> -                               ARRAY_SIZE(ptes[i].partition_name));
> +                               ARRAY_SIZE(pte->partition_name));
>                 info->volname[label_max] = 0;
>                 while (label_count < label_max) {
> -                       u8 c = ptes[i].partition_name[label_count] & 0xff;
> +                       u8 c = pte->partition_name[label_count] & 0xff;
>                         if (c && !isprint(c))
>                                 c = '!';
>                         info->volname[label_count] = c;
> --
> 2.18.0
