From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 2/6] efi/libstub: Allocate headspace in
 efi_get_memory_map()
Date: Mon, 22 Aug 2016 18:37:25 +0200
Message-ID: <20160822163724.GA11327@gmail.com>
References: <1471638904-3494-1-git-send-email-matt@codeblueprint.co.uk>
 <1471638904-3494-3-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1471638904-3494-3-git-send-email-matt@codeblueprint.co.uk>
Sender: stable-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Jeffrey Hugo <jhugo@codeaurora.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Leif Lindholm <leif.lindholm@linaro.org>, Mark Rutland <mark.rutland@arm.com>, stable@vger.kernel.org
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt@codeblueprint.co.uk> wrote:

> +	efi_boottime_memory_map_t map;
>  
>  	nr_desc = 0;
>  	e820ext = NULL;
>  	e820ext_size = 0;
> +	map.map = &mem_map;
> +	map.map_size = &map_sz;
> +	map.desc_size = &desc_size;
> +	map.desc_ver = &desc_version;
> +	map.key_ptr = &key;
> +	map.buff_size = &buff_size;

> +	*map->desc_size = sizeof(*m);
> +	*map->map_size = *map->desc_size * 32;
> +	*map->buff_size = *map->map_size;

> +	boot_map.map = (efi_memory_desc_t **)&map.map;
> +	boot_map.map_size = &map_size;
> +	boot_map.desc_size = &map.desc_size;
> +	boot_map.desc_ver = NULL;
> +	boot_map.key_ptr = NULL;
> +	boot_map.buff_size = &buff_size;

> +	boot_map.map = &map;
> +	boot_map.map_size = &map_size;
> +	boot_map.desc_size = &desc_size;
> +	boot_map.desc_ver = NULL;
> +	boot_map.key_ptr = NULL;
> +	boot_map.buff_size = &buff_size;

> +	efi_boottime_memory_map_t boot_map;
> +
> +	boot_map.map = &map;
> +	boot_map.map_size = &map_size;
> +	boot_map.desc_size = &desc_size;
> +	boot_map.desc_ver = NULL;
> +	boot_map.key_ptr = NULL;
> +	boot_map.buff_size = &buff_size;

> +	efi_boottime_memory_map_t map;
> +
> +	map.map = &runtime_map;
> +	map.map_size = &map_size;
> +	map.desc_size = &desc_size;
> +	map.desc_ver = &desc_ver;
> +	map.key_ptr = &mmap_key;
> +	map.buff_size = &buff_size;

> +	efi_boottime_memory_map_t map;
>  
> -	status = efi_get_memory_map(sys_table_arg, &memory_map, &map_size,
> -				    &desc_size, NULL, NULL);
> +	map.map = &memory_map;
> +	map.map_size = &map_size;
> +	map.desc_size = &desc_size;
> +	map.desc_ver = NULL;
> +	map.key_ptr = NULL;
> +	map.buff_size = &buff_size;

That's really ugly - if we do such initializations then at minimum they should be 
aligned vertically.

>  	u32 imagesize;
>  } efi_capsule_header_t;
>  
> +typedef struct {
> +	efi_memory_desc_t **map;
> +	unsigned long *map_size;
> +	unsigned long *desc_size;
> +	u32 *desc_ver;
> +	unsigned long *key_ptr;
> +	unsigned long *buff_size;
> +} efi_boottime_memory_map_t;

Ditto for structure definitions:

typedef struct {
	efi_memory_desc_t	**map;
	unsigned long		*map_size;
	unsigned long		*desc_size;
	u32			*desc_ver;
	unsigned long		*key_ptr;
	unsigned long		*buff_size;
} efi_boottime_memory_map_t;

Plus it would be nice to just use a proper structure name instead of a typedef - 
such as:

struct efi_boot_memmap {
	...
};

(Note that this name is also shorter)

... in the kernel we generally only use typedefs for short, synthetic types - 
bigger objects like this should be explicit structs - unless there's some strong 
reason to do it via a typedef.

Thanks,

	Ingo
