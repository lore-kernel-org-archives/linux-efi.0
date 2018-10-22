From: Baoquan He <bhe@redhat.com>
Subject: Re: [PATCH v9 8/8] x86/boot/KASLR: Limit kaslr to choosing the
 immovable memory
Date: Mon, 22 Oct 2018 18:24:55 +0800
Message-ID: <20181022102455.GN1885@192.168.1.4>
References: <20181017102012.872-1-fanc.fnst@cn.fujitsu.com>
 <20181017102012.872-9-fanc.fnst@cn.fujitsu.com>
 <20181018042123.GD1885@192.168.1.4>
 <20181022101329.GC7641@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181022101329.GC7641@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Chao Fan <fanc.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, keescook@chromium.org, msys.mizuma@gmail.com, indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com
List-Id: linux-efi@vger.kernel.org

On 10/22/18 at 06:13pm, Chao Fan wrote:
> >> +static bool process_mem_region(struct mem_vector *region,
> >> +			       unsigned long long minimum,
> >> +			       unsigned long long image_size)
> >> +{
> >> +	int i;
> >> +	/*
> >> +	 * If no immovable memory found, or MEMORY_HOTREMOVE disabled,
> >> +	 * walk all the regions, so use region directely.
> >> +	 */
> >> +	if (num_immovable_mem == 0) {
> >> +		slots_count(region, minimum, image_size);
> >> +
> >> +		if (slot_area_index == MAX_SLOT_AREA) {
> >> +			debug_putstr("Aborted e820/efi memmap scan (slot_areas full)!\n");
> >> +			return 1;
> >> +		}
> >> +		return 0;
> >> +	}
> >> +
> >> +#ifdef CONFIG_MEMORY_HOTREMOVE
> >> +	/*
> >> +	 * If immovable memory found, filter the intersection between
> >> +	 * immovable memory and region to slots_count.
> >> +	 * Otherwise, go on old code.
> >
> >Could you explain more about what is the old code in otherwise case you
> >want to go on?
> 
> Sure,
> 1. 'movable_node' not specified in cmdline.
> 2. CONFIG_HOT_REMOVE not difned.
> 3. Just one node in this machine.

So these cases are not covered by 'if (num_immovable_mem == 0)' code?
In thise ifdef code block, where do you handle above three cases?

Thanks
Baoquan
