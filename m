From: Timur Tabi <timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH v2] efi/libstub/arm*: Set default address and size cells
 values for an empty dtb
Date: Wed, 8 Mar 2017 17:32:53 -0600
Message-ID: <CAOZdJXX+tUeqq=CbwJ6oect2RLuB-VD5Ugzf6m6esmtPjJH5qw@mail.gmail.com>
References: <1486502360-18071-1-git-send-email-jhugo@codeaurora.org>
 <b901a792-5ca0-1489-6dcf-b17a66920bc6@arm.com> <9084badb-3340-fdca-9b41-8ab657d4bb15@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9084badb-3340-fdca-9b41-8ab657d4bb15-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Goel, Sameer" <sgoel-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Robin Murphy <robin.murphy-5wv7dgnIgG8@public.gmane.org>
Cc: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, AKASHI Takahiro <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Timur Tabi <timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Mar 2, 2017 at 9:23 AM, Goel, Sameer <sgoel-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org> wrote:

> Any tool making the device tree update should be checking for the cell sizes before
> assuming a 32 bit or a 64 bit value.

To be clear, Akashi's patches already look at the cell sizes:

+static int __init early_init_dt_scan_usablemem(unsigned long node,
+               const char *uname, int depth, void *data)
+{
+       struct memblock_region *usablemem = data;
+       const __be32 *reg;
+       int len;
+
+       if (depth != 1 || strcmp(uname, "chosen") != 0)
+               return 0;
+
+       reg = of_get_flat_dt_prop(node, "linux,usable-memory-range", &len);
+       if (!reg || (len < (dt_root_addr_cells + dt_root_size_cells)))
+               return 1;
+
+       usablemem->base = dt_mem_next_cell(dt_root_addr_cells, &reg);
+       usablemem->size = dt_mem_next_cell(dt_root_size_cells, &reg);
+
+       return 1;
+}

This function uses dt_root_addr_cells and dt_root_size_cells.  With
Sameer's patch, those values should be 2 and 2, respectively, on ARM64
systems.

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
