Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC3345D923
	for <linux-efi@vger.kernel.org>; Fri, 16 Oct 2026 09:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792141606; cv=none; b=GwkJb8FD5pMo9j68tNWMfgNXAU/9sRKoTcpgAVh6xjfmyon22+lK05JaD9rSoow49BWEMu14Z4WajGvsfy+lpWm0btmQfDTlsI8SN6vEiAMjyqOoySH5AD3RN0a0FEQdsjIcUQ8Z4xp5s2zegTh0777ZIUe3AJKHOXkgk3Gx/5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792141606; c=relaxed/simple;
	bh=5qWulNtGZLP4j4RpQP43yCcnIa88KyF9Yq365Xnc00o=;
	h=Date:From:To:Cc:Subject:Message-ID; b=plEnOhS6ds/zNDs9Zw8x5kEUsDDzBtXpdnuJixVREZccGj7MNB6mJmHuc/jjlfyxv5WYtcePFZ8TfjTUys0lc7RtBkbO3Wxa5E6+18f2UqfDevUl6qH3nSSWRLLMDe8TcI81Swfa2Q1ZuSPrvhZDF+C4zFST1e0m/ZxoxXu22N8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ednxXM40; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ednxXM40"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792141604; x=1823677604;
  h=date:from:to:cc:subject:message-id;
  bh=5qWulNtGZLP4j4RpQP43yCcnIa88KyF9Yq365Xnc00o=;
  b=ednxXM40GJzXFj4b3ND+K1TkthQnB6oekdwfuRsrBUtEk0sXFj+uKQeB
   5TSFR+OlXcrhRX1QPHf1xXcPaRgrxrU2sPvhBEz30+mRU265qxTdIKTKk
   zR0nvvJripj0EBYRsav9pzAgM6/o+Ck8u38XXd3MUCX73D41+Ydg9yuqG
   iJbhU8KFwCh2mI5U0aN0nf4iVdRlZr3+GPkiEHI4GXCwgqK4a9T6eET16
   iB3hRbiNQWRt1JuQLL7REadHc5XY17hQLnI4LrKPaIynfH8Y97YzaldRZ
   1ZBo+ZwP+DFidkeDImz7LXzvcpIGtFI6yfihVkXLG3gnVrwkQ5mAiUeSH
   g==;
X-CSE-ConnectionGUID: hSqpCJr3QLWB7Ub0REc1Dg==
X-CSE-MsgGUID: YDJp6G3wRhmd84bE1ojJgA==
X-IronPort-AV: E=McAfee;i="6800,10657,11936"; a="802756"
X-IronPort-AV: E=Sophos;i="6.27,161,1787036400"; 
   d="scan'208";a="802756"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2026 02:06:44 -0700
X-CSE-ConnectionGUID: 64F+3uSqQKi4XyqZnYpuzw==
X-CSE-MsgGUID: 761fskOcQTCg+31tBbNF1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,161,1787036400"; 
   d="scan'208";a="1969820"
Received: from igk-lkp-server01.igk.intel.com (HELO d0de6c2a75a7) ([10.211.93.152])
  by orviesa006.jf.intel.com with ESMTP; 16 Oct 2026 02:06:42 -0700
Received: from kbuild by d0de6c2a75a7 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xHdtg-00000000C9X-1Ef5;
	Fri, 16 Oct 2026 09:06:40 +0000
Date: Fri, 16 Oct 2026 11:05:55 +0200
From: kernel test robot <lkp@intel.com>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, linux-efi@vger.kernel.org,
 Kees Cook <kees@kernel.org>
Subject: [efi:next 27/27]
 drivers/firmware/efi/runtime-wrappers.c:350:51: error: passing argument 1 of
 'efi.runtime-><U4280>.get_time' from incompatible pointer type
Message-ID: <202610161027.zTUj3RVZ-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git next
head:   0d950fa5f7bfd3c9e7760a83b4970dc31603b043
commit: 0d950fa5f7bfd3c9e7760a83b4970dc31603b043 [27/27] lkdtm: Add more EFI runtime tests
config: loongarch-randconfig-2000-20261016 (https://download.01.org/0day-ci/archive/20261016/202610161027.zTUj3RVZ-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 16.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261016/202610161027.zTUj3RVZ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610161027.zTUj3RVZ-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from drivers/firmware/efi/runtime-wrappers.c:28:
   drivers/firmware/efi/runtime-wrappers.c: In function 'efi_call_rts':
>> drivers/firmware/efi/runtime-wrappers.c:350:51: error: passing argument 1 of 'efi.runtime-><U4280>.get_time' from incompatible pointer type [-Wincompatible-pointer-types]
     350 |                                        efi.runtime->set_virtual_address_map,
         |                                        ~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~
         |                                                   |
         |                                                   efi_status_t (*)(long unsigned int,  long unsigned int,  u32,  efi_memory_desc_t *) {aka long unsigned int (*)(long unsigned int,  long unsigned int,  unsigned int,  efi_memory_desc_t *)}
   include/linux/efi.h:1178:57: note: in definition of macro 'arch_efi_call_virt'
    1178 | #define arch_efi_call_virt(p, f, args...)       ((p)->f(args))
         |                                                         ^~~~
   drivers/firmware/efi/runtime-wrappers.c:349:26: note: in expansion of macro 'efi_call_virt'
     349 |                 status = efi_call_virt(get_time,
         |                          ^~~~~~~~~~~~~
   drivers/firmware/efi/runtime-wrappers.c:350:51: note: expected 'efi_time_t *' but argument is of type 'efi_status_t (*)(long unsigned int,  long unsigned int,  u32,  efi_memory_desc_t *)' {aka 'long unsigned int (*)(long unsigned int,  long unsigned int,  unsigned int,  efi_memory_desc_t *)'}
   include/linux/efi.h:1178:57: note: in definition of macro 'arch_efi_call_virt'
    1178 | #define arch_efi_call_virt(p, f, args...)       ((p)->f(args))
         |                                                         ^~~~
   drivers/firmware/efi/runtime-wrappers.c:349:26: note: in expansion of macro 'efi_call_virt'
     349 |                 status = efi_call_virt(get_time,
         |                          ^~~~~~~~~~~~~


vim +350 drivers/firmware/efi/runtime-wrappers.c

   240	
   241	/*
   242	 * Calls the appropriate efi_runtime_service() with the appropriate
   243	 * arguments.
   244	 */
   245	static void __nocfi efi_call_rts(struct work_struct *work)
   246	{
   247		const union efi_rts_args *args = efi_rts_work.args;
   248		efi_status_t status = EFI_NOT_FOUND;
   249		unsigned long flags;
   250	
   251		if (!efi_enabled(EFI_RUNTIME_SERVICES))
   252			efi_rts_park_worker();
   253	
   254		efi_runtime_lock_owner = current;
   255	
   256		arch_efi_call_virt_setup();
   257		flags = efi_call_virt_save_flags();
   258	
   259		switch (efi_rts_work.efi_rts_id) {
   260		case EFI_GET_TIME:
   261			status = efi_call_virt(get_time,
   262					       args->GET_TIME.time,
   263					       args->GET_TIME.capabilities);
   264			break;
   265		case EFI_SET_TIME:
   266			status = efi_call_virt(set_time,
   267					       args->SET_TIME.time);
   268			break;
   269		case EFI_GET_WAKEUP_TIME:
   270			status = efi_call_virt(get_wakeup_time,
   271					       args->GET_WAKEUP_TIME.enabled,
   272					       args->GET_WAKEUP_TIME.pending,
   273					       args->GET_WAKEUP_TIME.time);
   274			break;
   275		case EFI_SET_WAKEUP_TIME:
   276			status = efi_call_virt(set_wakeup_time,
   277					       args->SET_WAKEUP_TIME.enable,
   278					       args->SET_WAKEUP_TIME.time);
   279			break;
   280		case EFI_GET_VARIABLE:
   281			status = efi_call_virt(get_variable,
   282					       args->GET_VARIABLE.name,
   283					       args->GET_VARIABLE.vendor,
   284					       args->GET_VARIABLE.attr,
   285					       args->GET_VARIABLE.data_size,
   286					       args->GET_VARIABLE.data);
   287			break;
   288		case EFI_GET_NEXT_VARIABLE:
   289			status = efi_call_virt(get_next_variable,
   290					       args->GET_NEXT_VARIABLE.name_size,
   291					       args->GET_NEXT_VARIABLE.name,
   292					       args->GET_NEXT_VARIABLE.vendor);
   293			break;
   294		case EFI_SET_VARIABLE:
   295			status = efi_call_virt(set_variable,
   296					       args->SET_VARIABLE.name,
   297					       args->SET_VARIABLE.vendor,
   298					       args->SET_VARIABLE.attr,
   299					       args->SET_VARIABLE.data_size,
   300					       args->SET_VARIABLE.data);
   301			break;
   302		case EFI_QUERY_VARIABLE_INFO:
   303			status = efi_call_virt(query_variable_info,
   304					       args->QUERY_VARIABLE_INFO.attr,
   305					       args->QUERY_VARIABLE_INFO.storage_space,
   306					       args->QUERY_VARIABLE_INFO.remaining_space,
   307					       args->QUERY_VARIABLE_INFO.max_variable_size);
   308			break;
   309		case EFI_GET_NEXT_HIGH_MONO_COUNT:
   310			status = efi_call_virt(get_next_high_mono_count,
   311					       args->GET_NEXT_HIGH_MONO_COUNT.high_count);
   312			break;
   313		case EFI_UPDATE_CAPSULE:
   314			status = efi_call_virt(update_capsule,
   315					       args->UPDATE_CAPSULE.capsules,
   316					       args->UPDATE_CAPSULE.count,
   317					       args->UPDATE_CAPSULE.sg_list);
   318			break;
   319		case EFI_QUERY_CAPSULE_CAPS:
   320			status = efi_call_virt(query_capsule_caps,
   321					       args->QUERY_CAPSULE_CAPS.capsules,
   322					       args->QUERY_CAPSULE_CAPS.count,
   323					       args->QUERY_CAPSULE_CAPS.max_size,
   324					       args->QUERY_CAPSULE_CAPS.reset_type);
   325			break;
   326		case EFI_ACPI_PRM_HANDLER:
   327	#ifdef CONFIG_ACPI_PRMT
   328			status = arch_efi_call_virt(args, ACPI_PRM_HANDLER.acpi_prm_handler,
   329						    args->ACPI_PRM_HANDLER.param_buffer_addr,
   330						    args->ACPI_PRM_HANDLER.context);
   331			break;
   332	#endif
   333		default:
   334			/*
   335			 * Ideally, we should never reach here because a caller of this
   336			 * function should have put the right efi_runtime_service()
   337			 * function identifier into efi_rts_work->efi_rts_id
   338			 */
   339			pr_err("Requested executing invalid EFI Runtime Service.\n");
   340			break;
   341	
   342	#if IS_ENABLED(CONFIG_LKDTM)
   343		case EFI_LKDTM_RUNTIME_RO_TEST:
   344			/*
   345			 * Call GetTime() with the output argument pointing to
   346			 * executable memory, which should be mapped read-only in the
   347			 * EFI page tables.
   348			 */
   349			status = efi_call_virt(get_time,
 > 350					       efi.runtime->set_virtual_address_map,
   351					       NULL);
   352			break;
   353		case EFI_LKDTM_RUNTIME_NX_TEST:
   354			/*
   355			 * Call efi.runtime, which points to a data object in a EFI
   356			 * runtime region, as if it were a function pointer.
   357			 */
   358			struct { efi_status_t (__efiapi *fn)(int); } s = { (void *)efi.runtime };
   359	
   360			status = arch_efi_call_virt((&s), fn, 0);
   361			break;
   362	#endif
   363		}
   364	
   365		efi_call_virt_check_flags(flags, efi_rts_work.caller);
   366		arch_efi_call_virt_teardown();
   367	
   368		/*
   369		 * EFI runtime services may also have been disabled because the
   370		 * firmware faulted, but the caller is still waiting for us in that
   371		 * case. Only park the worker if the caller has given up on it.
   372		 */
   373		if (READ_ONCE(efi_rts_abandoned))
   374			efi_rts_park_worker();
   375	
   376		efi_rts_work.status = status;
   377		complete(&efi_rts_work.efi_rts_comp);
   378		efi_runtime_lock_owner = NULL;
   379	}
   380	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
