Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B6C545D92F
	for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 11:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790248025; cv=none; b=n3DdTMZoo/BMvElDMx3rvPBj47lfmn+oWNGdOOx1Jwi5v88ghGANvWSRyNseaZKLAjVYWA0uMXkcN/KX8apxs8SMgFzFCyHTBPslurWLBxHZiMnQ+ozUEwKTHTfEolIJ0Z6Dx2hfYGX6cMsVvp9dpI9i7feV+pur2OJ7s/EJJHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790248025; c=relaxed/simple;
	bh=yrI+URhESve6HspNSDzOp1zvNel+JG1IKi2qkoCondc=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=hkkQVDr2XUV93rvngtyMnCJY2I+JJm0StooATtfawgsN5E6e1FDba2Pu2w/WebGrn/HSY2bCEz/vMMCvci1pjm9PNMZV251fbjqOu36wKa9XZA5+xHaXgok8uJLBsjV6edeM85jGzurTvrWbb8Db4TdHr6LSVxivode/Q66k3bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=brd0+XcZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="brd0+XcZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E16391F00893;
	Thu, 24 Sep 2026 11:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790248019;
	bh=V83SDi+TUKENS52JUz3LtD47/hn1tvgx9IbuoycR/fs=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=brd0+XcZ+T/++LOIA8GlDMksB2c6WU9A6TT+j/FD6hT2mnAX4p7ZMC28gJLwIZgTM
	 kxZT49ruolfPZuPDZD+srOdTGi8ucS1YuuWvZphubO3ONKH34eIqreEvxF1vvE4TVh
	 gQ+6ZvR7H4o04QgdQ6AghgsokUd3RM7FnM/ZPY8eEtfZ7rIUKY5MUdeLNusqKgdRj0
	 HKV2TD6a6d/eqjI/APsysiaQMxF9gvDniZoIuesNMrTnJO2LRQwNkrraAm8JOpcWy1
	 ZnzxoVz3ntVoTmoOeJyFRZ7r/NQtrQKWDV64bgH5JO5aJMZJs0eguD8rvStpKkIFtz
	 DtNdVUMgnezcA==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 6A3231980058;
	Thu, 24 Sep 2026 07:06:57 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Thu, 24 Sep 2026 07:06:57 -0400
X-ME-Sender: <xms:UAS1aixT8NOaKJwLfpkEB33FUo1rJI0RVZdIEGnWfZqYkrKef3yHEg>
    <xme:UAS1apHFK9gEOhNU2twu2mTvTQS9P3JuzXlvD9cjkOB9prvPTTnuclMWcL97yktkg
    grCa6I5ljFXgOl6PrIP8tcc6ouOFyXa1VRiwMo1J3DXHtRGLDwWHTM>
X-ME-Proxy-Cause: dmFkZTF7LK1rs7PqibZaYl6YD5o4BdJnxPzTa9Znv2PsJIIQl0yV0gEmFLbqPJxoOQaArn
    QgwNXR9LaaoW0zNd6tnIr5ccKRJm/GPwwrxIoXCpg8RW5k+7LrI6NGaxnSc4qJ3oES3emt
    qtDjzkAA+tjZ9GbhCiJpPXdkxHXehMrK+JVb6QdlGSIBvPlVPcpxhOGm9ZYaOccfy2db3M
    yH6IuoEI4E/PfcvNbNV2+9Yj/CrNhWhF3DvF8HlRJKiPUC68asHg/cVucKXVSjXBmvDwQh
    uCqVjTdooIOAAsVlKDLul9RfKct4b31VO5BzEln4RP+j/3ZEqSUfqsEKl5y8Nv6+WVUbex
    CSvWF2xpJE0qwupL4w9rNVt8iXQvnVFSGXN8zt6qM9i7G1kroqzpVQTT8N5S0/SKi02gxj
    AMcp3xLJ8Y3zfJSgize8E/J1Z/TMFCpTaPxgg96cfx/CW6GjzkWBS/UhpjrTbt8GYxHyy5
    pXqWzBGmYzEw6IO6paV9s/T7JoHRihDSNPOA3f3ukdL8nlj1mtkOPJnobhNs9T3qVmKdKH
    9osBF6Btx2OTod3oS9SVg/DF91tfLAwVQ8/RE+i4w+CDaZPHrWIDp1gZKuF4QjvzHYxmPQ
    OEBXpfgh3xn75yDDwWgZ/D6a2gtfFyf9aH/+WQl4dX94ZrjJ00IvB0e/nR2A
X-ME-Proxy: <xmx:UQS1aubkipL416tQEisSo9bDGL2N9HqxD33ITnBAy2_nrv4oJmetVg>
    <xmx:UQS1as1naPVe8n80heAOWYjq-YYW7pQvb_JInvMSey5rM4OzuNTALQ>
    <xmx:UQS1asdznUlqyMk9KJXQFQ7XjTFHpd2Rm70VQlc26IS2ap6x_DII3Q>
    <xmx:UQS1alH8rzZ2IS6YdvmoblTLbxQhl60VyHYoUC2YCyZQLLsyHwkZmw>
    <xmx:UQS1al3HXeFmRqHM7vo-gjotzAIQzlIy8FXVlj0aL44kS-Qc5ScjsQXF>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 1D23BF80080; Thu, 24 Sep 2026 07:06:56 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 24 Sep 2026 13:06:35 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: jaidevshastri@vt.edu, "Ilias Apalodimas" <ilias.apalodimas@linaro.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <501132b4-eba0-4bf8-a9c0-0c209e1bee3a@app.fastmail.com>
In-Reply-To: <20260921-mb-efi-capsule-v1-1-fbf2a2032afb@vt.edu>
References: <20260921-mb-efi-capsule-v1-1-fbf2a2032afb@vt.edu>
Subject: Re: [PATCH] efi: capsule: publish capsule_pending after efi_reset_type
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hello Jaidev,

On Tue, 22 Sep 2026, at 03:09, Jaidev Shastri via B4 Relay wrote:
> From: Jaidev Shastri <jaidevshastri@vt.edu>
>
> efi_capsule_update_locked() sets capsule_pending and then
> efi_reset_type, both with plain stores. efi_capsule_pending() reads them
> from the reboot path without capsule_mutex.
>
> The comment above efi_capsule_pending() covers a caller that misses the
> update entirely. It does not cover the other outcome: with neither the
> stores nor the loads ordered, a caller can observe capsule_pending set
> and efi_reset_type still -1, and the reboot path then acts on a capsule
> with an invalid reset type.
>
> Write efi_reset_type first and publish the flag with
> smp_store_release(), paired with smp_load_acquire() in
> efi_capsule_pending(). A caller that misses the update entirely still
> behaves as documented.
>
> Found with MBCheck, a static herd7-based memory consistency checker.
>
> Signed-off-by: Jaidev Shastri <jaidevshastri@vt.edu>
> ---
>  drivers/firmware/efi/capsule.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>

I think the tool's conclusion is correct that concurrent execution
of efi_capsule_pending() and efi_capsule_update() may result in the
re-ordering and subsequent misreporting of the EFI reset type.

However, in practice, efi_capsule_pending() is only called on the
reboot path after all other CPUs have been stopped, so there is
really nothing to fix here.



> diff --git a/drivers/firmware/efi/capsule.c b/drivers/firmware/efi/capsule.c
> index dd6252638..2129007d8 100644
> --- a/drivers/firmware/efi/capsule.c
> +++ b/drivers/firmware/efi/capsule.c
> @@ -50,7 +50,8 @@ static DEFINE_MUTEX(capsule_mutex);
>   */
>  bool efi_capsule_pending(int *reset_type)
>  {
> -	if (!capsule_pending)
> +	/* Pairs with the smp_store_release() in efi_capsule_update_locked(). */
> +	if (!smp_load_acquire(&capsule_pending))
>  		return false;
> 
>  	if (reset_type)
> @@ -173,8 +174,14 @@ efi_capsule_update_locked(efi_capsule_header_t *capsule,
> 
>  	status = efi.update_capsule(&capsule, 1, sglist_phys);
>  	if (status == EFI_SUCCESS) {
> -		capsule_pending = true;
>  		efi_reset_type = reset;
> +		/*
> +		 * efi_capsule_pending() reads the flag without capsule_mutex
> +		 * and then the reset type, which is stored above. Publish the
> +		 * flag with release semantics so that a reader that sees it
> +		 * also sees the matching reset type.
> +		 */
> +		smp_store_release(&capsule_pending, true);
>  	}
> 
>  	return efi_status_to_err(status);
>
> ---
> base-commit: 93f51579e7df248780214094418f205253383cc5
> change-id: 20260921-mb-efi-capsule-d111fa00ae80
>
> Best regards,
> --  
> Jaidev Shastri <jaidevshastri@vt.edu>
