#! /bin/bash
#SBATCH --mem=35G
#SBATCH -o ./out/%A.%x.%a.out # STDOUT
#SBATCH -e ./err/%A.%x.%a.err # STDERR
#SBATCH --array=1-617%50
#SBATCH --partition=carter-compute



samples=(SRR7228529 SRR7228436 SRR7228410 SRR7228433 SRR7228591 SRR7228593 SRR7228324 SRR7228655 SRR7228291 SRR7228728 SRR7228321 SRR7228316 SRR7228247 SRR7228786 SRR7228344 SRR7228182 SRR7228364 SRR7228255 SRR7228464 SRR7228590 SRR7228185 SRR7228388 SRR7228516 SRR7228503 SRR7228299 SRR7228672 SRR7228173 SRR7228565 SRR7228251 SRR7228527 SRR7228168 SRR7228736 SRR7228305 SRR7228507 SRR7228193 SRR7228656 SRR7228616 SRR7228698 SRR7228474 SRR7228500 SRR7228718 SRR7228446 SRR7228198 SRR7228760 SRR7228353 SRR7228318 SRR7228512 SRR7228256 SRR7228396 SRR7228227 SRR7228754 SRR7228688 SRR7228300 SRR7228197 SRR7228709 SRR7228563 SRR7228651 SRR7228510 SRR7228359 SRR7228603 SRR7228178 SRR7228689 SRR7228329 SRR7228270 SRR7228538 SRR7228611 SRR7228595 SRR7228768 SRR7228763 SRR7228614 SRR7228330 SRR7228228 SRR7228428 SRR7228398 SRR7228425 SRR7228780 SRR7228758 SRR7228485 SRR7228767 SRR7228639 SRR7228325 SRR7228654 SRR7228486 SRR7228195 SRR7228729 SRR7228452 SRR7228380 SRR7228601 SRR7228424 SRR7228239 SRR7228784 SRR7228694 SRR7228340 SRR7228568 SRR7228657 SRR7228414 SRR7228552 SRR7228714 SRR7228617 SRR7228553 SRR7228789 SRR7228264 SRR7228233 SRR7228260 SRR7228231 SRR7228772 SRR7228755 SRR7228588 SRR7228550 SRR7228515 SRR7228458 SRR7228179 SRR7228171 SRR7228518 SRR7228478 SRR7228703 SRR7228547 SRR7228192 SRR7228606 SRR7228659 SRR7228306 SRR7228551 SRR7228188 SRR7228501 SRR7228477 SRR7228724 SRR7228632 SRR7228554 SRR7228757 SRR7228429 SRR7228539 SRR7228293 SRR7228290 SRR7228262 SRR7228519 SRR7228312 SRR7228269 SRR7228706 SRR7228683 SRR7228536 SRR7228664 SRR7228479 SRR7228257 SRR7228506 SRR7228368 SRR7228488 SRR7228301 SRR7228741 SRR7228219 SRR7228378 SRR7228648 SRR7228404 SRR7228562 SRR7228332 SRR7228761 SRR7228358 SRR7228489 SRR7228558 SRR7228712 SRR7228287 SRR7228401 SRR7228335 SRR7228415 SRR7228586 SRR7228266 SRR7228280 SRR7228722 SRR7228750 SRR7228402 SRR7228450 SRR7228643 SRR7228265 SRR7228756 SRR7228319 SRR7228386 SRR7228392 SRR7228440 SRR7228625 SRR7228492 SRR7228230 SRR7228229 SRR7228438 SRR7228778 SRR7228599 SRR7228451 SRR7228579 SRR7228785 SRR7228618 SRR7228273 SRR7228336 SRR7228690 SRR7228744 SRR7228235 SRR7228472 SRR7228777 SRR7228405 SRR7228677 SRR7228369 SRR7228238 SRR7228223 SRR7228461 SRR7228252 SRR7228481 SRR7228218 SRR7228746 SRR7228619 SRR7228470 SRR7228253 SRR7228653 SRR7228390 SRR7228533 SRR7228555 SRR7228413 SRR7228304 SRR7228366 SRR7228629 SRR7228548 SRR7228710 SRR7228532 SRR7228633 SRR7228283 SRR7228354 SRR7228217 SRR7228740 SRR7228213 SRR7228561 SRR7228731 SRR7228268 SRR7228508 SRR7228747 SRR7228377 SRR7228243 SRR7228531 SRR7228520 SRR7228752 SRR7228444 SRR7228201 SRR7228560 SRR7228387 SRR7228275 SRR7228696 SRR7228172 SRR7228626 SRR7228499 SRR7228566 SRR7228524 SRR7228637 SRR7228475 SRR7228212 SRR7228674 SRR7228391 SRR7228261 SRR7228733 SRR7228771 SRR7228530 SRR7228504 SRR7228680 SRR7228249 SRR7228628 SRR7228383 SRR7228385 SRR7228509 SRR7228751 SRR7228776 SRR7228574 SRR7228333 SRR7228289 SRR7228525 SRR7228624 SRR7228604 SRR7228338 SRR7228343 SRR7228189 SRR7228725 SRR7228556 SRR7228707 SRR7228282 SRR7228242 SRR7228310 SRR7228409 SRR7228569 SRR7228635 SRR7228660 SRR7228585 SRR7228721 SRR7228271 SRR7228170 SRR7228577 SRR7228546 SRR7228734 SRR7228341 SRR7228302 SRR7228623 SRR7228543 SRR7228263 SRR7228294 SRR7228742 SRR7228465 SRR7228286 SRR7228206 SRR7228196 SRR7228692 SRR7228702 SRR7228200 SRR7228244 SRR7228783 SRR7228615 SRR7228216 SRR7228297 SRR7228621 SRR7228676 SRR7228540 SRR7228345 SRR7228673 SRR7228311 SRR7228183 SRR7228782 SRR7228363 SRR7228667 SRR7228432 SRR7228226 SRR7228732 SRR7228373 SRR7228248 SRR7228437 SRR7228342 SRR7228453 SRR7228284 SRR7228279 SRR7228180 SRR7228749 SRR7228665 SRR7228759 SRR7228608 SRR7228395 SRR7228204 SRR7228408 SRR7228441 SRR7228505 SRR7228716 SRR7228576 SRR7228602 SRR7228462 SRR7228693 SRR7228308 SRR7228743 SRR7228684 SRR7228704 SRR7228241 SRR7228399 SRR7228276 SRR7228181 SRR7228594 SRR7228246 SRR7228491 SRR7228705 SRR7228523 SRR7228573 SRR7228745 SRR7228381 SRR7228435 SRR7228541 SRR7228431 SRR7228467 SRR7228697 SRR7228638 SRR7228661 SRR7228535 SRR7228208 SRR7228487 SRR7228564 SRR7228351 SRR7228352 SRR7228650 SRR7228460 SRR7228362 SRR7228484 SRR7228681 SRR7228769 SRR7228587 SRR7228288 SRR7228445 SRR7228469 SRR7228292 SRR7228320 SRR7228649 SRR7228668 SRR7228502 SRR7228323 SRR7228439 SRR7228281 SRR7228720 SRR7228700 SRR7228727 SRR7228581 SRR7228582 SRR7228497 SRR7228259 SRR7228184 SRR7228328 SRR7228307 SRR7228406 SRR7228347 SRR7228466 SRR7228254 SRR7228375 SRR7228686 SRR7228393 SRR7228557 SRR7228766 SRR7228423 SRR7228187 SRR7228612 SRR7228647 SRR7228442 SRR7228748 SRR7228666 SRR7228559 SRR7228679 SRR7228739 SRR7228765 SRR7228592 SRR7228303 SRR7228426 SRR7228456 SRR7228787 SRR7228315 SRR7228726 SRR7228498 SRR7228607 SRR7228570 SRR7228225 SRR7228545 SRR7228418 SRR7228376 SRR7228448 SRR7228205 SRR7228717 SRR7228770 SRR7228245 SRR7228779 SRR7228483 SRR7228468 SRR7228584 SRR7228610 SRR7228176 SRR7228699 SRR7228326 SRR7228419 SRR7228662 SRR7228480 SRR7228514 SRR7228322 SRR7228567 SRR7228691 SRR7228580 SRR7228202 SRR7228272 SRR7228447 SRR7228791 SRR7228528 SRR7228781 SRR7228701 SRR7228572 SRR7228215 SRR7228397 SRR7228589 SRR7228427 SRR7228773 SRR7228658 SRR7228169 SRR7228537 SRR7228459 SRR7228513 SRR7228493 SRR7228313 SRR7228494 SRR7228627 SRR7228407 SRR7228670 SRR7228645 SRR7228379 SRR7228250 SRR7228190 SRR7228416 SRR7228774 SRR7228678 SRR7228630 SRR7228454 SRR7228534 SRR7228298 SRR7228605 SRR7228214 SRR7228642 SRR7228575 SRR7228434 SRR7228622 SRR7228631 SRR7228370 SRR7228412 SRR7228207 SRR7228420 SRR7228571 SRR7228620 SRR7228482 SRR7228737 SRR7228258 SRR7228613 SRR7228278 SRR7228495 SRR7228708 SRR7228675 SRR7228711 SRR7228646 SRR7228473 SRR7228764 SRR7228652 SRR7228174 SRR7228600 SRR7228211 SRR7228682 SRR7228455 SRR7228669 SRR7228634 SRR7228403 SRR7228355 SRR7228583 SRR7228597 SRR7228544 SRR7228361 SRR7228715 SRR7228640 SRR7228636 SRR7228417 SRR7228337 SRR7228609 SRR7228210 SRR7228685 SRR7228346 SRR7228762 SRR7228209 SRR7228194 SRR7228695 SRR7228449 SRR7228517 SRR7228443 SRR7228730 SRR7228457 SRR7228348 SRR7228317 SRR7228723 SRR7228522 SRR7228526 SRR7228221 SRR7228644 SRR7228578 SRR7228596 SRR7228220 SRR7228735 SRR7228277 SRR7228598 SRR7228372 SRR7228222 SRR7228360 SRR7228490 SRR7228175 SRR7228356 SRR7228309 SRR7228549 SRR7228542 SRR7228236 SRR7228274 SRR7228471 SRR7228663 SRR7228753 SRR7228394 SRR7228232 SRR7228186 SRR7228430 SRR7228314 SRR7228719 SRR7228296 SRR7228788 SRR7228331 SRR7228790 SRR7228421 SRR7228203 SRR7228775 SRR7228177 SRR7228334 SRR7228349 SRR7228327 SRR7228234 SRR7228350 SRR7228382 SRR7228521 SRR7228411 SRR7228687 SRR7228511 SRR7228496 SRR7228240 SRR7228199 SRR7228422 SRR7228285 SRR7228374 SRR7228713 SRR7228400 SRR7228339 SRR7228191 SRR7228389 SRR7228463 SRR7228641 SRR7228671 SRR7228738 SRR7228237 SRR7228224 SRR7228267)
sample=${samples[$SLURM_ARRAY_TASK_ID-1]}


date

input_dir=/cellar/controlled/dbgap-genetic/phs001572_PD1_pantumor/aligned
output_dir=/cellar/users/mpagadal/immunotherapy-trials/data/bams

cd $output_dir

samtools view -b $input_dir/$sample.recal.bam chr1 > $output_dir/$sample.chr1.recal.bam
samtools index $output_dir/$sample.chr1.recal.bam

date
