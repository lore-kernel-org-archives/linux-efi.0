From: Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH v2] efi: take size of partition entry from GPT header
Date: Wed, 12 Sep 2018 10:38:44 +0200
Message-ID: <20180912083844.iegei2kobcz4b7ag@ws.net.home>
References: <20180911161527.GA30689@vnote>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180911161527.GA30689@vnote>
Sender: linux-kernel-owner@vger.kernel.org
To: Eugene Korenevsky <ekorenevsky@gmail.com>, Davidlohr Bueso <dave@stgolabs.net>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Sep 11, 2018 at 07:15:27PM +0300, Eugene Korenevsky wrote:
> +static gpt_entry *get_gpt_entry(gpt_header *gpt_hdr, gpt_entry *ptes, u32 index)
> +{
> +	return (gpt_entry *)((u8 *)ptes + gpt->sizeof_partition_entry * index);

I guess header use LE, so you need:

               le32_to_cpu(gpt_hdr->sizeof_partition_entry)

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
