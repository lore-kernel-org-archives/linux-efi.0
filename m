From: Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [PATCH v3] efi: take size of partition entry from GPT header
Date: Wed, 12 Sep 2018 11:55:17 -0700
Message-ID: <20180912185517.GE3902@linux-r8p5>
References: <20180912183519.GA31506@vnote>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180912183519.GA31506@vnote>
Sender: linux-kernel-owner@vger.kernel.org
To: Eugene Korenevsky <ekorenevsky@gmail.com>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 12 Sep 2018, Eugene Korenevsky wrote:
> /**
>  * efi_partition(struct parsed_partitions *state)
>  * @state: disk parsed partitions
>@@ -704,32 +710,36 @@ int efi_partition(struct parsed_partitions *state)
>
> 	pr_debug("GUID Partition Table is valid!  Yea!\n");
>
>-	for (i = 0; i < le32_to_cpu(gpt->num_partition_entries) && i < state->limit-1; i++) {
>+	for (i = 0;
>+	     i < le32_to_cpu(gpt->num_partition_entries) && i < state->limit-1;
>+	     i++) {

Please rearrange this like:

       for (i = 0;  < le32_to_cpu(gpt->num_partition_entries) &&
       	      	      i < state->limit-1; i++)

>+		gpt_entry *pte = get_gpt_entry(gpt, ptes, i);
> 		struct partition_meta_info *info;
> 		unsigned label_count = 0;
> 		unsigned label_max;
>-		u64 start = le64_to_cpu(ptes[i].starting_lba);
>-		u64 size = le64_to_cpu(ptes[i].ending_lba) -
>-			   le64_to_cpu(ptes[i].starting_lba) + 1ULL;
>+		u64 start = le64_to_cpu(pte->starting_lba);
>+		u64 size = le64_to_cpu(pte->ending_lba) -
>+			   le64_to_cpu(pte->starting_lba) + 1ULL;
>
>-		if (!is_pte_valid(&ptes[i], last_lba(state->bdev)))
>+		if (!is_pte_valid(pte, last_lba(state->bdev)))
> 			continue;
>
> 		put_partition(state, i+1, start * ssz, size * ssz);
>
> 		/* If this is a RAID volume, tell md */
>-		if (!efi_guidcmp(ptes[i].partition_type_guid, PARTITION_LINUX_RAID_GUID))
>+		if (!efi_guidcmp(
>+		    pte->partition_type_guid, PARTITION_LINUX_RAID_GUID))

This is ugly. If you are worried about 80-chars, please do:

     	      	 if (!efi_guidcmp(pte->partition_type_guid,
				PARTITION_LINUX_RAID_GUID))

Thanks,
Davidlohr
